<p align="center">
  <img src="bits_logo.jpg" width="400">
</p>

# BITS Meeting - Travel Grant assignment
Algorithm for **Travel Grants** ranking and assignment for the annual meetings of the **Bioinformatics Italian Society (BITS)**.

### Priority ranking
The script automates the selection process based on the priority rules approved by the organizing committee.
The ranking is calculated across 5 priority rounds:
* **Priority 1**: BITS members, age < 35, no previous BITS Travel Grant received.
* **Priority 2**: BITS members, age ≥ 35, no previous BITS Travel Grant received.
* **Priority 3**: New membership applicants, no previous Travel Grant.
* **Priority 4**: Not BITS members, no previous Travel Grant.
* **Priority 5**: Applicants who have previously received a BITS Travel Grant.

### Requirements
```r
install.packages(c("tidyverse", "readxl", "writexl", "lubridate"))
```
