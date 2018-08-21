# Haskell Concurrency Exercise

I was inspired by Dan Friedman's [concurrent-wc](https://github.com/dan-f/concurrent-wc) project
(implementing `wc -l ./dir` in a number of languages and thought it would be fun to try
to see how much performance I could get out of a Haskell implementation.

I found when I profiled the Haskell implementation of concurrent-wc that only
30% of the time work was being shared relatively evenly between the
4 system threads on my macbook (found via threadscope) and that over 95% of the
work was being spent in counting newlines.

![original.png](https://github.com/nicksanford/haskell-concurrency-exercise/blob/master/images/original.png)

This is a simplified version of that implementation which still is not able to
efficiently parallelize work between 4 cores (the vast majority of work is
done by a single system thread) despite the fact that I spawn a green thread per
file.

![new.png](https://github.com/nicksanford/haskell-concurrency-exercise/blob/master/images/new.png)

I have added thread tracing information and a `./profile.sh` script to generate
profiling information.

You will want to have [stack](https://docs.haskellstack.org/en/stable/README/)
and [threadscope](https://github.com/haskell/ThreadScope) installed before running
`./profile.sh`.

If you have any insight on how to properly parallelize this work I would love
to hear from you!
