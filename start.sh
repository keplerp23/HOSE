#!/bin/bash
Rscript -e "pr <- plumber::plumb('api.R'); pr$run(host='0.0.0.0', port=8000)"