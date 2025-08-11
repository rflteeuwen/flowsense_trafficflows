# Traffic FlowSense
This repository contains code to estimate traffic flows from sparse mobile phone geolocation data, as part of the [FlowSense](https://research.chalmers.se/en/project/11639) research project. The code is written in PostgresSQL with PostGIS, and Python Jupyter Notebooks.

This code was developed for the cities of Stockholm and Gothenburg, Sweden, but can be adapted to other geographic settings world-wide.

More information can be found in the accompanying paper "Estimating traffic flows from vehicle trajectories based on sparse mobile phone geolocation data", to be presented at the [NetMob 2025](https://netmob.org/www25/) conference. 

## Using Traffic_FlowSense?

If you use Traffic_FlowSense in your work, please cite the accompanying conference paper:

**Citation info:** [accepted for publication] Roos Teeuwen and Jorge Gil (2025). Estimating traffic flows from vehicle trajectories based on sparse mobile phone geolocation data. NetMob 2025 conference. Paris, France: Conservatoire national des arts et métiers.

**Data:** Associated datasets, including pseudonimized data on people's perceptions of places, are available at [zenodo link](https://zenodo.org/)

**Introduction:** Large-scale empirical traffic flow data are instrumental in spatial planning, transport research, and data-driven decision making. However, existing data, collected using traffic sensors or counts, lack spatio-temporal coverage and granularity. While mobile phone geolocation data are deemed promising for capturing traffic at scale given their size, granularity, and coverage, their potential for such cases remains unexplored. In this study, we investigate how traffic flows with high granularity and extensive coverage can be estimated from vehicle trajectories based on sparse mobile phone gelocation data. We introduce our data-processing methodology, implement it on two major cities in Sweden, and compare our outcomes to ground truth data. The flows resulting from our methodology yielded significant and strong correlations with the ground truth data. At highway locations in Gothenburg, very strong correlations were observed when selecting trajectories of at least 20 km/h on average as input. Future work remains to understand where and why deviations remain, and how correlations can be strengthened further, opening up new possibilities for data-driven transport, environmental and planning research as well as practice.
