#!/usr/bin/env python
# coding: utf-8

# # Spark 101: Reading and Writing Data with Spark
# 
# This notebook is inspired by https://www.udacity.com/course/learn-spark-at-udacity--ud2002 and is an attempt to better understand PySpark.
# 

# In[1]:


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


# ## Creating an RDD
# 
# There are few ways to create RDDs:
#    1) distributing a set of collection objects
#    2) loading an external dataset

# ### 1) distributing a set of collection objects using ***parallelize()***

# In[22]:


spark = SparkSession     .builder     .appName("Python Spark create RDD example")     .config("spark.some.config.option", "some-value")     .getOrCreate()

df = spark.sparkContext.parallelize(
    [(1, 2, 3, 'a b c'), # row 1
     (4, 5, 6, 'd e f'), 
     (7, 8, 9, 'g h i')]).toDF(['col1', 'col2', 'col3','col4'])


# This gives us the following RDD:

# In[12]:


df.show()


# In[14]:


spark = SparkSession     .builder     .appName("Python Spark create RDD example")     .config("spark.some.config.option", "some-value")     .getOrCreate()

myData = spark.sparkContext.parallelize([(1,2), (3,4), (5,6), (7,8), (9,10)])


# In[15]:


myData.collect()


# ### 2) distributing a set of collection objects using ***createDataFrame()***

# In[18]:


spark = SparkSession     .builder     .appName("Python Spark create RDD example")     .config("spark.some.config.option", "some-value")     .getOrCreate()

Employee = spark.createDataFrame([
                        ('1', 'Joe',   '70000', '1'),
                        ('2', 'Henry', '80000', '2'),
                        ('3', 'Sam',   '60000', '2'),
                        ('4', 'Max',   '90000', '1')],
                        ['Id', 'Name', 'Sallary','DepartmentId'])


# In[21]:


Employee.show()


# ### 3) Reading dataset from a file

# In[2]:


# create a Spark session
spark = SparkSession     .builder     .appName("Sparkify_Project")     .getOrCreate()


# In[3]:


df = "mini_sparkify_event_data.json"
df = spark.read.json(df)


# In[4]:


df.printSchema()


# There are a few other useful methods to read files from SQL databases and from HDFS. For further information https://runawayhorse001.github.io/LearningApacheSpark/rdd.html

# Lets use the describe method to see what we can learn form the data

# In[5]:


df.describe()


# Describe returns the columns in the dataset and their respective types. We can also look at particular records, lets see what the first one looks like.

# In[6]:


df.show(n=1)


# Now that we have successfully loaded the DataFrame, let see how we can save it into a different format such as CSV format. 

# In[34]:


out_path = "mini_sparkify_event_data.csv"


# In[35]:


df.write.save(out_path,format = "csv", header = True)


# Now lets load the CSV file which we just saved into a DataFrame:

# In[36]:


df_csv = spark.read.csv(out_path, header = True)


# Now lets check Schema of the CSV file

# In[37]:


df_csv.printSchema()


# It is exactly the same as before.
# We can also take a look at the first few records.

# In[39]:


df_csv.show(n=1)


# In[42]:


df_csv.take(1)


# In[40]:


df_csv.select("userID").show()

