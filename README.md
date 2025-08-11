# FlowSense - Traffic Flows
This repository contains code to estimate traffic flows from sparse mobile phone geolocation data, as part of the [FlowSense](https://research.chalmers.se/en/project/11639) research project. The estimated flows yield significant and (very) strong correlations with various ground truth datasets. With this research project, and making our code and data openly available, we intend to open up new possibilities for data-driven transport, environment and planning research as well as practice. 

The code is written in PostgresSQL with PostGIS, and Python Jupyter Notebooks. It was developed for the cities of Stockholm and Gothenburg, Sweden, but can be adapted to other geographic settings world-wide.

More information can be found in the accompanying paper "Estimating traffic flows from vehicle trajectories based on sparse mobile phone geolocation data", to be presented in October 2025 at the [NetMob 2025](https://netmob.org/www25/) conference. 

## Using flowsense_trafficflows?

If you use flowsense_trafficflows in your work, please cite the accompanying conference paper:

**Citation info:** [accepted for publication] Teeuwen, R., & Gil, J. (2025). *Estimating traffic flows from vehicle trajectories based on sparse mobile phone geolocation data*. NetMob 2025 conference. Paris, France: Conservatoire national des arts et métiers.

**Data:** Associated datasets, including estimated flows, road network data and ground truth data, are available at [zenodo link](https://zenodo.org/). Geolocation points and trajectories cannot be made public due to privacy restrictions.

**License:**
This repository is licensed under the [GNU General Public License v3.0 (GPL-3.0)](https://www.gnu.org/licenses/gpl-3.0.html).

**Abstract:** Large-scale empirical traffic flow data are instrumental in spatial planning, transport research, and data-driven decision making. However, existing data, collected using traffic sensors or counts, lack spatio-temporal coverage and granularity. While mobile phone geolocation data are deemed promising for capturing traffic at scale given their size, granularity, and coverage, their potential for such cases remains unexplored. In this study, we investigate how traffic flows with high granularity and extensive coverage can be estimated from vehicle trajectories based on sparse mobile phone gelocation data. We introduce our data-processing methodology, implement it on two major cities in Sweden, and compare our outcomes to ground truth data. The flows resulting from our methodology yielded significant and strong correlations with the ground truth data. At highway locations in Gothenburg, very strong correlations were observed when selecting trajectories of at least 20 km/h on average as input. Future work remains to understand where and why deviations remain, and how correlations can be strengthened further, opening up new possibilities for data-driven transport, environmental and planning research as well as practice.

**Acknowledgements:**
This research is funded by Chalmers University of Technology Transport Area of Advance under grant agreement no. 2024-0299.
