# Generate reports

The program help management to get reporting about marketing materials consumption in offices all around the world.

The project is designed for quick and easy generation of reports, which helps to assess which marketing material is most popular.

---

## How to use

### Installation
The project is written in `Ruby` language.
For ease of use was created `Gemfile` where are all gems stored.

In order to start the project, you need to run a several of commands:

To install all the required dependencies
```
bundle install --without dev
```

To create the required tables in the database created a script `create_structure.rb`

_Before that, make sure that you have created a base fpr the project, enter its data into `env.rb`_
```
ruby script_create_structure.rb
```
If everything is dote correctly, you will see the message: `Succeeded connection to database` and messages about creating tables

* To start, you need execute the last command

```zsh
cd ./App
rackup

# or this
rackup ./App/config.ru
```

### Deinstallation

To uninstall run the commands.

_Before deleting the database, make sure that there is no important data there or make backup. Script **delete schema** of this database_

```shell
ruby script_drop_tables.rb

cd ..
rm -rf mobidev-generate-reports
```

### Upload data
_url: `/upload_data/`_

After starting the program, follow the link "upload data" and download the file in `csv` format.

If everything worked correctly and you did not receive an error message, then you can return to the main page.

### States report
_url: `/reports/states/<STATE_NAME>`_

A report is generated with a list of offices for each state.

To get information on a specific state, use `/reports/states/<STATE_NAME>`

![states report](dop_images/state_report.png)

### Fixtures report
_url: `/reports/offices/fixture_types`_

A report is generated with a list of offices for each fixtures type and their number in this office.

If you want to see how many of which marketing materials are in a given office and their quantity by type, use `/reports/offices/<OFFICE_ID>/fixture_types`

![fixtures report](dop_images/fixture_report.png)

### Marketing materials cost report

_url: `/reports/offices/marketing_materials`_

A report is generated with a list of marketing materials for each offices and their cost in this office.

To display the infographic, we used `Chart.js`

![](dop_images/mm_report.png)

### Office Installation Instructions report
_url: `/reports/offices/installation`_

This report should help staff in the office to place marketing materials in the right places

You will be taken to the search page for the desired office, initially the entire list of offices will be shown.

To proceed, use the search page or `/reports/offices/<OFFICE_ID>/installation`


![](dop_images/inst_report.png)

---

## Documentation
Project has the following structure. 

If you want to change this structure, make sure you change all dependencies

```
mobidev-generate-reports/
 ├── App/
 │    ├── config.ru
 │    ├── controllers/
 │    │    ├── modules/
 │    │    │   └── insert_module.rb
 │    │    ├── fixture_report.rb
 │    │    ├── marketing_cost_report.rb
 │    │    ├── office_installation_report.rb
 │    │    ├── root.rb
 │    │    ├── search_office.rb
 │    │    ├── state_report.rb
 │    │    └── upload_data.rb
 │    ├── public/
 │    │    └── css/
 │    │        ├── installation.css
 │    │        ├── search.css
 │    │        ├── styles.css
 │    │        └── upload.css
 │    └── templates/
 │        ├── fixture_report.erb
 │        ├── fixture_report_by_office.erb
 │        ├── materials_report.erb
 │        ├── office_installation.erb
 │        ├── root.erb
 │        ├── search_offices_reports.erb
 │        ├── states_report.erb
 │        └── upload.erb
 ├── Gemfile
 ├── env.rb
 ├── script_create_structure.rb
 └── script_drop_tables.rb
```

### Database
This database was developed, according to the term of reference and according to the given data. Report will be generated based on this data.

* This is a drawing according to which it was necessary to compose a database for storing data without duplicates and quickly searching through them.

![office drawing](dop_images/office_drawing.png)

Upon close examination of this drawing, such connections between the data were revealed.

```sh
"offices" 1-* "zones"
"zones" 1-* "rooms"
"rooms" 1-* "fixtures"
"fixtures" 1-1 "marketing_materials"
```

Further, according to these links, a base diagram was created, with fields that correspond to the incoming data.

![database structure](dop_images/database_diagram.png)


