FROM python:3.8.5
EXPOSE 8501
WORKDIR /app
COPY requirements-app.txt ./requirements-app.txt
RUN pip3 install -r requirements-app.txt
COPY . .
ARG MLFLOW_TRACKING_URI
ENV MLFLOW_TRACKING_URI=$MLFLOW_TRACKING_URI
ENV ARTIFACT_LOCATION='s3_mlflow'
# Need to provide build arg to set env variable from host env variable:
# https://vsupalov.com/docker-build-pass-environment-variables/
CMD streamlit run app.py $ARTIFACT_LOCATION --server.port $PORT 

# streamlit-specific commands for config
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN mkdir -p /root/.streamlit
RUN bash -c 'echo -e "\
[general]\n\
email = \"\"\n\
" > /root/.streamlit/credentials.toml'

RUN bash -c 'echo -e "\
[server]\n\
enableCORS = false\n\
" > /root/.streamlit/config.toml'

# docker build --build-arg MLFLOW_TRACKING_URI -t mlops_tutorial.

# docker run -e PORT=8501 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID 
#   -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -it mlops_tutorial
