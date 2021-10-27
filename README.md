# Generate reports

The program help management to get reporting about marketing materials consumption in offices all around the world.

The project is designed for quick and easy generation of reports, which helps to assess which marketing material is most popular.

---

## How to use

### Installation
The project is written in `Ruby` language.
For ease of use was created `Gemfile` where are all gems stored.

In order to start the project, you need to run a several of commands:

* To install all the required dependencies
```
bundler install
```

* To create the required tables in the database created a script `create_structure.rb`

```
ruby script_create_structure.rb
```
* To start, you need to go to the folder with the application `./App` and execute the last command


```zsh
cd ./App
rackup

# or this
rackup ./App/config.ru
```

### Deinstallation


---

## Documentation

```
mobidev_generate_reports/
 ├── App/
 │   ├── config.ru
 │   ├── controllers/
 │   │   ├── modules/
 │   │   │   └── insert_module.rb
 │   │   ├── state_report.rb
 │   │   └── upload_data.rb
 │   └── templates/
 │       └── states_report.erb
 ├── Gemfile
 ├── README.md
 ├── database_diagram.png
 ├── script_create_structure.rb
 └── script_drop_tables.rb
```

### Database

![](database_diagram.png)