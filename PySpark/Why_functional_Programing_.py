#!/usr/bin/env python
# coding: utf-8

# # Spark: Why Functional Programing?
# 
# This notebook is inspired by https://www.udacity.com/course/learn-spark-at-udacity--ud2002
# 
# This notebook provides a basic example which illustrates why **functional programing** is used in parallel distributed systems instead of procedural programing

# In[1]:


log_of_songs = [
        "Despacito",
        "Nice for what",
        "No tears left to cry",
        "Despacito",
        "Havana",
        "In my feelings",
        "Nice for what",
        "Despacito",
        "All the stars"
]


# In[2]:


play_count = 0


# In[31]:


def count_songs_global(song_name):
    global play_count
    for song in log_of_songs:
        if song == song_name:
            play_count = play_count +1
    return play_count


# In[32]:


count_songs_global("Despacito")


# In[33]:


count_songs_global("Despacito")


# However, if we implement play_count as a local variable we can solve this problem:

# In[30]:


def count_songs_local(song_name):
    play_count = 0
    for song in log_of_songs:
        if song == song_name:
            play_count = play_count +1
    return play_count


# In[34]:


count_songs_local("Despacito")


# **So why can't we just use the local implementation in Spark?** In parallel programing our data would be split up onto multiple computers. Machine 1 would first need to finish counting, and then return its results to Machine 2. Only then Machine 2 could begin counting (since Machine 2 needs the output from Machine 1)
# 
# But this not parallel computing. This is very inefficent since Machine 2 has to wait until Machine 1 completes the computation.
# 
# **How does Spark over come this?**
# Spark solves this issue by using *functional programming* instead of *procedural programming*. In Spark, if our data is split onto two different machines, Machine 1 will run a function that counts the number of times *change this* 
# 
# In distributed systems, your function shouldn't have side effects on variables outside their scope. Since that could interfere with other funtions running on the cluster
