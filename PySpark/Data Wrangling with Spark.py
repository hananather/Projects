#!/usr/bin/env python
# coding: utf-8

# # Data Wrangling with PySpark and SQL Spark
# 
# 

# In[2]:


import numpy as np
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf
from pyspark.sql import Window
from pyspark.sql import functions as F
from pyspark.sql.functions import sum as Fsum
from pyspark.sql.types import ArrayType, BooleanType, LongType, FloatType, IntegerType
from pyspark.sql.functions import lit, udf, struct, countDistinct, collect_list, avg, count, col
from pyspark.ml.feature import VectorAssembler, Normalizer, StandardScaler
from pyspark.ml.classification import LogisticRegression, RandomForestClassifier, GBTClassifier
from pyspark.ml.evaluation import MulticlassClassificationEvaluator, BinaryClassificationEvaluator
from pyspark.ml import Pipeline
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve
from sklearn.metrics import precision_recall_curve
from pyspark.ml.tuning import CrossValidator, ParamGridBuilder


# In[15]:


spark = SparkSession     .builder     .appName("Wrangling Data")     .getOrCreate()
user_log.createOrReplaceTempView("log_table")


# In[4]:


path = "mini_sparkify_event_data.json"
user_log = spark.read.json(path)


# # Data Exploration 
# 
# Now we explore the data

# In[5]:


user_log.count()


# In[8]:


user_log.describe("artist").show()


# In[9]:


user_log.describe("sessionId").show()


# In[12]:


user_log.select("page").dropDuplicates().sort("page").show()


# In[6]:


get_hour = udf(lambda x: datetime.datetime.fromtimestamp(x / 1000.0). hour)


# In[7]:


user_log = user_log.withColumn("hour", get_hour(user_log.ts))


# In[9]:


songs_in_hour = user_log.filter(user_log.page == "NextSong").groupby(user_log.hour).count().orderBy(user_log.hour.cast("float"))


# ## How many females are in this dataset?

# In[12]:


user_log.filter(user_log.gender == 'F')     .select('userId', 'gender')     .dropDuplicates()     .count()


# In[ ]:


We can also use Spark SQL instead of spark


# In[16]:


spark.sql("SELECT COUNT(DISTINCT userID)             FROM log_table             WHERE gender = 'F'").show()


# ## Who is the most played artist and how many songs did they play?

# In[18]:


user_log.filter(user_log.page == 'NextSong')     .select('Artist')     .groupBy('Artist')     .agg({'Artist':'count'})     .withColumnRenamed('count(Artist)','Artistcount')     .show()


# In[17]:


spark.sql("SELECT Artist, COUNT(Artist) AS plays         FROM log_table         GROUP BY Artist         ORDER BY plays DESC         LIMIT 1").show()


# In[ ]:




