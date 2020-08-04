
docker build . --tag rocker/r-parallel
docker run -p 1234:8000 rocker/r-parallel
