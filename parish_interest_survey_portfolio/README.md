# Parish Interest Survey Analytics Pipeline

<!--
ONE-SENTENCE SUMMARY:
What did you build, with what, and why?

Example structure:
"An end-to-end analytics engineering project using dbt and BigQuery to transform
parish interest survey data into tested, documented dimensional models for
ministry-interest analysis."

Keep this to 1–2 sentences.
-->
An end-to-end people analytics project, which uses dbt and BigQuery to transform a parish ministry interest survey from a Google Forms output into a tested and documented dimensional model for ministry-interest analysis. This project built an end-user requested directory of interest in particular ministries as identified by respondents to the survey.
## Project Overview

<!--
Answer:
- What was the original business problem?
- What kind of data did you start with?
- What does the finished pipeline make possible?
- Who would consume the resulting data?

Aim for one short paragraph. Don't explain implementation details yet.
-->
Developer was asked to create a persistent directory of respondents and contact information according to their interest in particular volunteer ministries at an Eastern Orthodox parish. The data was originally collected in the form of a Google Forms survey and given to developer as an .xsls file. The finished pipeline provides a directory in the form of a Looker dashboard which enables filtering by interest and person. This data can be consumed by clergy and ministry leaders for the purposes of outreach and recruitment for the particular ministries.

For purposes of portfolio display, this repository contains an anonymous version of the survey results, with names drawn from the Bethesda title *The Elder Scolls IV: Oblivion* and phone numbers generated from random string of 6 digit numbers. 
## End Product
<!--
![Parish interest dashboard](docs/images/dashboard.png)
-->

## Architecture

```
Anonymized Survey CSV
        ↓
     BigQuery
        ↓
   dbt Sources
        ↓
     Staging
        ↓
   Intermediate
        ↓
      Marts
   ↙         ↘
Dimensions   Fact
   ↘          ↙
Ministry Interest Report
        ↓
Looker Dashboard Directory
```

The anonymized source CSV is loaded into BigQuery with quoted newlines enabled before dbt transformations are executed. This was done to eliminate .csv file formatting breakdowns that presented fatal errors at a layer the developer could not directly edit. Such breakdowns were caused by the free-text survey responses allowing line breaks.

<!--
OPTIONAL:
Explain WHY quoted newlines matter in one sentence if free-text survey responses
can contain line breaks. This demonstrates that the setting is intentional rather
than incidental.
-->

### Technology Stack

<!--
List only technologies actually used.

Possible entries:
- BigQuery — warehouse
- dbt Core — transformation, testing, documentation
- SQL — transformations / QA
- Git / GitHub — version control
- Looker Studio — visualization, if applicable
-->

| Technology           | Role                                                 |
| -------------------- | ---------------------------------------------------- |
| BigQuery             | Data warehouse                                       |
| dbt Core             | Transformation, modeling, testing, and documentation |
| SQL                  | Data transformation and QA                           |
| Git / GitHub         | Version control and development workflow             |
| Looker Studio        | Visualized end-product for ministry consumption      |

## Data Modeling

<!--
Explain the important modeling decisions, NOT every SQL statement.

Useful questions:
- What is the source grain?
- Why did the grain need to change?
- What dimensions/facts did you create?
- Why is the final fact-table grain useful?
-->

The source grain coming from the Forms survey consisted of one record per response, which many ministries potentially being represented at time of response. In order to form dimensions, the responses needed to be exploded in order to accord a grain of one positive response per ministry. Developer formed two dimension tables, one for unique responses and another for unique ministries. The fact table joins positive interest in available ministries by response. This enables a clean set of simple joins to produce the directory table in a report consumed by Looker.

### Source Grain

The source survey is modeled initially at one row per submitted response.

**Grain:** `one row per response`

### Staging Layer

<!--
What does staging do?

Examples:
- rename source fields
- standardize types
- clean/null values
- generate response identifiers
- preserve original response grain

Mention what staging deliberately DOESN'T do if useful.
-->
The staging layer carries out minimal transformations, consisting only of renaming columns, testing for unique and not null columns in full_name, response_id, and submitted_at columns, and generating a response identifier column. No grain transformations take place at this layer.

### Intermediate Layer

<!--
Explain the transformations between clean source data and the dimensional model.

This is a good place to discuss:
- boolean ministry-interest fields
- unpivoting
- grain changes
- reusable transformations

Don't drown the reader in implementation detail.
-->
Two major transformations occur here. First, a text checking function transforms the free response column ministry_interest into a boolean feature set of whether the respondent was interested in a ministry or not. Secondly, this wide feature set is unpivoted into a long collection of one response per positive ministry interest.

### Mart Layer


| Model           | Grain                                            | Purpose                                                                  |
| --------------- | ------------------------------------------------ | ------------------------------------------------------------------------ |
| `dim_responses` | One row per unique respondent | Records all unique responses gathered by the survey |
| `dim_ministry`  | One row per unique ministry                                 | Records all ministries available for selection in the original survey    |
| `fact_interest` | One row per expressed response–ministry interest | Records positive ministry-interest relationships for downstream analysis |


## Data Quality

Data quality was maintained via both dbt's schema testing suite and a custom Quality Assurance model built as a developer side reporting view.

### dbt Tests

Tests implemented include
- not_null
- unique
- relationships

dbt tests validate the following:

* uniqueness of primary/surrogate keys
* non-null required identifiers
* referential integrity between fact and dimensions


### QA Analysis

The project includes a QA analysis comparing observed model outputs against known structural expectations.

| Check                             | Expected |
| --------------------------------- | -------: |
| Source response count             |       45 |
| Distinct modeled responses        |       45 |
| Distinct ministries               |       15 |
| Duplicate response–ministry pairs |        0 |
| Null fact foreign keys            |        0 |

<!--
If you include a screenshot or sample output later, put it here.

Example:
![QA results](docs/images/qa-results.png)
-->

## dbt Documentation

Model and column documentation is maintained alongside the dbt project using schema YAML files and reusable dbt documentation blocks. The schema YAML files contain columnar descriptions, or references to doc block entries in the case of repeated columns. These can be served as an HTML file through dbt's `dbt docs` command. 

Data lineage is documented through a DAG generated by dbt, as seen below.

<!-- OPTIONAL:
![dbt lineage graph](docs/images/dbt-lineage.png)
-->

## Repository Structure

```text
parish_interest_survey_portfolio/
├── analyses/
│   └── qa_table.sql
├── data/
├── macros/
├── models/
│   ├── docs/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── dbt_project.yml
├── packages.yml
└── README.md
```


## Running the Project
### Prerequisites

* Python
* dbt Core with the BigQuery adapter
* Access to a Google BigQuery project
* A configured dbt BigQuery profile

### 1. Clone the repository

```bash
git clone <!-- repository URL -->
cd parish_interest_survey_portfolio
```

### 2. Install dbt dependencies

```bash
dbt deps
```

### 3. Load the source data

Load the anonymized source CSV into BigQuery with **quoted newlines enabled**.

### 4. Validate the project

```bash
dbt debug
```

### 5. Build and test

```bash
dbt build
```

### 6. Generate documentation

```bash
dbt docs generate
dbt docs serve
```

## Development Workflow

<!--
Briefly explain your Git process.

Example:
"Development is performed on feature branches and integrated into main through
pull requests."

Mention this because it demonstrates workflow discipline, but don't turn the
README into a Git tutorial.
-->

Development is performed on feature branches and integrated into `main` through pull requests. Final cleanups and quick commits were completed on `main` towards the end of the project.

## CI/CD and Deployment Trade-offs

This project does not use warehouse-backed automated CI/CD. BigQuery access is configured through interactive multi-factor authentication, and the project is maintained by a single developer rather than a multi-contributor team.

Because of this, the added complexity of introducing a non-interactive service identity, secret management, and automated warehouse execution was not justified for this portfolio implementation.

Data integrity is instead validated through local `dbt build` / `dbt test` execution and an explicit QA analysis that checks known cardinalities, duplicate grain violations, and null foreign keys, as seen above.

In a production team environment, the natural next step would be to introduce a dedicated CI service identity and require automated dbt validation on pull requests before merge, which would conduct similar checks.


## Key Design Decisions

<!--
THIS IS A VERY GOOD PORTFOLIO SECTION.

Pick perhaps 3–5 decisions where there was actually something to decide.

Potential examples from this project:

### Preserve response grain through staging
Explain why.

### Model ministry interests at response × ministry grain
Explain why the wide survey format was unsuitable for analysis.

### Store only positive interests in the fact table
Explain why this represents the business event you care about.

### Separate dimensions from the interest fact
Explain why.

### Manual source ingestion
Explain why ingestion automation was outside project scope.

Do NOT invent complexity merely to fill this section.
-->

### <!-- Decision 1 -->

<!-- What did you decide? Why? What alternative existed? -->

### <!-- Decision 2 -->

<!-- What did you decide? Why? -->

### <!-- Decision 3 -->

<!-- What did you decide? Why? -->

## Limitations and Future Improvements

<!--
Demonstrate that you know where the project boundary is.

Potential REAL improvements:
- service identity + warehouse-backed CI
- automated ingestion
- orchestration/scheduling
- incremental models, IF volume ever justified them
- source freshness checks
- production/dev environment isolation

IMPORTANT:
Don't apologize for these. Explain them as things that become appropriate under
different scale/operating requirements.
-->

Potential extensions for a production implementation include:

* <!-- improvement -->
* <!-- improvement -->
* <!-- improvement -->

## What This Project Demonstrates

<!--
This is the portfolio payoff. Keep it short.

Think competencies, not buzzwords:
- dimensional modeling
- grain management
- dbt DAG design
- data quality/testing
- BigQuery
- documentation
- Git workflow
- architectural trade-off reasoning
-->

This project demonstrates:

* <!-- competency -->
* <!-- competency -->
* <!-- competency -->
* <!-- competency -->

## Data Privacy

<!--
VERY IMPORTANT because this originated from real parish survey data.

State:
- repository data is anonymized
- personally identifying information is excluded
- public project does not expose production/private data

Be precise about whatever you actually did.
-->

The source data included in this repository has been anonymized for public use.

<!-- Add another sentence explaining what was removed/transformed, if appropriate. -->
