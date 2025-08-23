#!/bin/bash

# Получить текущую структуру проекта
cd lib/
ls -R "$(pwd)" > project_structure.txt