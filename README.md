# The dataset

The California Department of Drinking Water (DDW) maintains a huge [database](https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/EDTlibrary.html) of millions of water quality measurements taken throughout the state going back decades. Here is some code that lets you load those data into an SQL database for fast and easy loading.

# Setting up the database

Build the image using:

```shell
docker build -t edt-db .
```

An image is a set of instructions for building a perfectly configured computer. But you can't actually do anything useful until you use those instructions to make a container.

Next, create and instance of that container. Containers are flesh-and-blood computer services that actually do things like run software, host services, etc.


```shell
docker run --name my-edt -p 3306:3306 edt-db
```

# Loading the data into the database

Because I don't know enough about the mariaSQL docker image, I wasn't able to have docker actually add the data to the database during the build process. So there's this strange little extra step that is almost certainly not the right way to do it. But we like breaking the rules, don't we? To summarize, docker built us a perfect little virtual computer running a SQL database. We need to log into that computer and run a script that will dump the contents of the DBF files into the SQL database.

```shell
# log into the container
docker exec -it my-edt bash
# the next command runs *inside* the container
>>> sh /data/add_edt.sh
# this will take several hours to run
>>> exit
```

# Connecting to the database

Now you have a wonderful little SQL server that can serve up millions of water quality measurements. But first we need to know its address, which starts with knowing a bit about how docker does networking. You can examine the networks that docker sets up using `docker network inspect <network_name>`. In this case (and many basic cases), you will use the default docker network called `bridge`.

```shell
docker network inspect bridge
```

The command `docker network inspect bridge` will display the information for the bridge network and all instances connected to it. Look for your instance name. For example, my instance is called `my-edt` so it's IPv4 address is 172.17.0.2.
```
"Containers": {
    "c00d496cb04f544166f5296c2bf832e5f5daea04010325540a101844da49072e": {
        "Name": "my-edt",
        "EndpointID": "491497d70091d58945403f7d308162ccf681134c6959212f32a729c87885fbff",
        "MacAddress": "02:42:ac:11:00:02",
        "IPv4Address": "172.17.0.2/16",
        "IPv6Address": ""
    },
```

(A quicker way is to get this info is:

```shell
docker inspect -f "{{ .NetworkSettings.IPAddress }}" <container_name>
```

but where's the fun in that?)

You can now connect using any SQL library. Check out the [notebook](https://github.com/r-b-g-b/ddw-water-quality-sql/blob/master/notebooks/008-edt-exploration.ipynb) for an example in Python using [datasets](https://dataset.readthedocs.io/en/latest/). Happy querying!

# Links
 - [Electronic Data Transfer Library](https://www.waterboards.ca.gov/drinking_water/certlic/drinkingwater/documents/edtlibrary/WQM%20DOCUMENTATION.doc): The Department of Drinking Water's page for this data. This contains a lot of useful documentation.