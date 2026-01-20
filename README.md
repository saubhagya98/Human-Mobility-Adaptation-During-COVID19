# Human-Mobility-Adaptation-During-COVID19
Data-driven modelling (Unsupervised Machine Learning) to identify the changes in human mobility patterns during the COVID -19 Outbreak in Sri Lanka using a Nationwide Door-to-Door Survey. 

**Original Dataset:** [Harvard Dataverse DOI: 10.7910/DVN/CXMJSM](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/CXMJSM)

## Mobility Impact Variables
Extracted Dataset" 
In the dataset variables, **PP** stands for Pre-Pandemic, **FP** for First Wave, **SP** for Second Wave, and **TP** for Third Wave.
### Frequency Scale
Most mobility variables are measured using the following 4-point Likert scale:
- **1:** Never
- **2:** Less often
- **3:** Often
- **4:** Very Often

### 3C.1 Access to Food Sources
Measures the frequency of accessing various food supply points:
- sof_neighborhood_shop: Neighborhood shops/stores
- sof_main_super_market: Main Super Markets
- sof_mini_super_market: Mini super markets
- sof_home_delivery_or_mobile_shops: Home delivery/mobile shops
- sof_own_field: Own fields
- sof_govt_ngo: Government/NGO sources
- sof_online: Online shopping
- sof_neighbors: Neighbors
- sof_fairs: Fairs (local markets) in cities/villages

### 3C.2 Access to Financial Localities
Tracks interaction with financial services:
- fin_bank_city: Bank in town/city
- fin_bank_near: Bank nearby
- fin_local_financial: Local financial institutes (e.g., Sanasa)
- fin_atm_city: ATM in city
- fin_atm_near: ATM nearby
- fin_online_banking: Online banking
- fin_post_office: Post office

### 3C.3 Leisure and Social Activities
Measures non-essential movement:
- lei_trips: Trips/Excursions
- lei_recreational: Recreational places
- lei_social_gathering: Social Gatherings

### 3C.4 General Transportation Modes
Tracks the mode of transport used for general purposes:
- mot_public: Public transport
- mot_shared_vehi: Shared vehicles (School/Staff vans)
- mot_hired: Hired three-wheelers
- mot_own_vehicle: Own motor vehicles
- mot_bicycle: Bicycles
- mot_walking: Walking

---

### 3C.5 Work-Related Mobility and Interaction
These variables focus on employment-related movement and the level of physical exposure in the workplace.

#### 3C.5.1 Work Location Patterns
- w_work_from_home: Work from home
- w_come_from_home: Commute from home
- w_come_from_renthouse: Commute from rented/boarding place
- w_come_from_commonhostel: Commute from common hostel

#### 3C.5.2 Work Transportation
Specifically captures the mode of transport used for commuting to work (Public, Shared, Hired, Own Vehicle, Bicycle, or Walking).

#### 3C.5.3 Level of Human Interaction at Work
Assesses social density and exposure risk:
- w_alone_home: Working alone at home
- w_with_few_known: Working with a few known people
- w_with_few_known_lim_unknown: Working with regular few known people and limited unknown people
- w_with_few_irre_unknown: Working with irregular few unknown people
- w_with_large_irre_unknown: Working with irregular large groups

## Data Transformation
### 1. Symmetric Linear Scaling
To reflect both the **magnitude** and **direction** of behavioral changes, Likert-scale questionnaire items were recorded on a symmetric directional scale:
* **Scale Values:** `[-1.5, -1, 1, 1.5]`
### 2. Capturing Pandemic-Induced Change
The primary metric for analysis is the "Behavioral Change" score.

**Transformation Formula:**
$$\Delta \text{Behavior} = \text{Pre-Pandemic Value} - \left( \frac{\text{First Wave Value} + \text{Second Wave Value} + \text{Third Wave Value}}{3} \right)$$

Code: [preprocessData](./scripts/preprocessData.py)

Processed Dataset:[a1_dataset](./data/output/a1_dataset.csv) 

## Exploratory Factor Analysis
The exploratory factor analysis (EFA) process involved identifying principal factors via Principal Component Analysis (PCA), followed by a varimax rotation to maximize loading variance. The analysis was conducted in IBM SPSS, with items retained if their factor loadings were above 0.4 and those with significant cross-loadings removed. 

[ExploratoryFactorAnalysis.spv](./ExploratoryFactorAnalysis.spv)

## Cluster Analysis
A sequential clustering approach where the optimal number of clusters was first identified using a sigma-sweep-based spectral clustering procedure, after which the k-means algorithm was applied to the feature space to define the final behavioral archetypes.

[Spectral Clustering](./scripts/Spectral_Clustering.py)

[K-Means Clustering](./scripts/KMeans_Clustering.py)

## Mobility Trends
[Mobility Trends](./scripts/Mobility_Trends.R)

## Reliability and Validity
The confirmatory factor analysis (CFA) was conducted using robust maximum likelihood estimation with Huber-White robust standard errors and Yuan-Bentler scaled test statistics to account for departures from multivariate normality, yielding an acceptable incremental model fit.

[CFA](./scripts/CFA.R)
