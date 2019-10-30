FROM ruby:2.5.0 as base

RUN apt-get update && apt-get install -y gnuplot

RUN useradd -u 1000 gnuplot; \
    mkdir -p /home/gnuplot/gnuplot; \
    chown gnuplot.gnuplot -R /home/gnuplot

WORKDIR /home/gnuplot/gnuplot

USER gnuplot
RUN gem install jeweler2
