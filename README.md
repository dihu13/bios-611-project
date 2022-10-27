Project 1 Bios 611
==================
Game of Throne (GOT) -- The War of the Five Kings
------------------------

Proposal
--------

### Introduction

Game of Thrones is a hit fantasy tv show based on the equally famous book series "A Song of Fire and Ice" by George RR Martin. The show is well known for its vastly complicated political landscape, large number of characters, and its frequent character deaths.

The War of the Five Kings is a important part of the show/book. Here we will analyse the battles and the kings to get some interesting facts.

We will use some machine learning technique to predict the death of characters. Also, I want to find out which family is the most likely to die, that is, or the one that has died the most times. 


### Datasets

The datasets we undertake to analyze are publicly available on Kaggle. They can be downloaded [](https://www.kaggle.com/datasets/mylesoneill/game-of-thrones?resource=download).

This repo will eventually contain an analysis of
the GOT Dataset.

### Preliminary Figures

![](assets/pie-chart.png)

The above figure shows that Joffery/Tommen Baratheon and Robb Stark got involeved most battles. 


Usage
-----

You'll need Docker and the ability to run Docker as your current user.

You'll need to build the container:

    > docker build . -t project-env

This Docker container is based on rocker/verse. To run rstudio server:

    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
      -e PASSWORD=mypassword -t project-env
      
Then connect to the machine on port 8787.

If you are cool and you want to run this on the command line:

    > docker run -v `pwd`:/home/rstudio -e PASSWORD=some_pw -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; R"
    
Or to run Bash:

    > docker run -v `pwd`:/home/rstudio -e PASSWORD=some_pw -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"

Makefile
========

The Makefile is an excellent place to look to get a feel for the project.

To build figures relating to the distribution of super powers over
gender, for example, enter Bash either via the above incantation or
with Rstudio and say:

    > make figures/gender_power_comparison.png 