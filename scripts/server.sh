#!/bin/bash

rm -rf _public
rm app/assets/index.html
rm app/assets/partials/*.html
rm app/assets/partials/meetings/*.html
rm app/assets/partials/newsletter/*.html
node_modules/.bin/brunch watch --server
