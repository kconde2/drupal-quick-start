#!/bin/bash

mkdir drupal/sites/default/files
chmod a+w drupal/sites/default/files

cp drupal/sites/default/default.settings.php drupal/sites/default/settings.php
chmod a+w drupal/sites/default/settings.php

docker-compose up

# chmod go-w drupal/sites/default/settings.php
