# ExLog

Logger implementation challenge for [safeboda.com](safeboda.com) interview.

* A logger reads and write data directly from and to the file system, and the
  file system is backed up by a disk, which might be the bottleneck of a
  computing system.

* It writes the log lines in order, in other words, a log file is sorted by
  timestamp.

* Also it is a good practice to rotate log files at some moment, like every day,
  or after certain size.

* Other important thing is, a logger is a shared component, there might be a
  lot of processes using it and trying to log data.

In this exercise, we will try to implement a logger, or at least part of it.
The idea is start identifying simple and quick improvements,
and then think a bout how to make it better,
more efficient and ready to deal with high concurrency.

Go to `ExLog.Server` module and follow the instructions in the doc.
