# Thread safety, another thread changes the memory other threads using.
# Disadvantage of multi workers: Other worker may not have same packages loaded
# @everywhere works for those workers started in the beginning
# pmap(10:-1:1): vs pmap(1:10) , similar to particle filter, running computationally heavy tasks for workers let worker to be busy
# in the beginning, so that no other workers waiting for other workers.
# When there is a lot of allocation, threading will not help speed up, if one thread is using slow memory 
# Garbage collector on one computer is shared by different threads