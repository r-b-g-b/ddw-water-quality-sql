FROM mariadb:10.3.10-bionic

RUN apt-get update && \
    apt-get install dbf2mysql -y
ENV MYSQL_ROOT_PASSWORD=my-secret-pw

RUN apt-get install curl unzip -y

RUN mkdir /data
RUN curl https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/documents/edtlibrary/chemical.zip \
    -o /data/chemical.zip
RUN unzip /data/chemical.zip -d /data
RUN rm /data/chemical.zip

RUN curl https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/documents/edtlibrary/storet.zip \
    -o /data/storet.zip
RUN unzip /data/storet.zip -d /data
RUN rm /data/storet.zip

ADD add_edt.sh /data/add_edt.sh

# RUN pip install datasets dbfread

# RUN mkdir /code
# ADD convert_dbf_to_mysql.py /code/convert_dbf_to_mysql.py
# RUN python convert_dbf_to_mysql.py
