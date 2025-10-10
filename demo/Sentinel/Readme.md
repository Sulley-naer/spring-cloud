# Sentinel Dashboard

> [!IMPORTANT]
> Alibaba Sentinel is a powerful flow control component that provides flow control, circuit breaking, and system adaptive protection for microservices architectures.

## Overview

Sentinel is an open-source project by Alibaba designed to provide protection for distributed systems at scale. In this microservices architecture, Sentinel serves as the traffic control and service protection component, ensuring system stability under high load conditions.

## Features

- **Flow Control**: Rate limiting for specific resources based on various metrics
- **Circuit Breaking**: Protection against cascading failures in distributed systems
- **System Adaptive Protection**: Self-adaptive protection based on system metrics
- **Real-time Monitoring**: Dashboards and metrics for service behavior
- **Hotspot Parameter Protection**: Fine-grained control based on request parameters

## Integration in This Project

Sentinel is integrated into this microservices architecture as follows:

1. **Service Protection**: Applied to both `product-service` and `order-service` modules via Spring Cloud Alibaba Sentinel starter
2. **Dashboard**: Provides a web UI to monitor service metrics and configure rules
3. **Configuration**: Rules can be configured through the dashboard and are synchronized to the running services

## Docker Configuration

Sentinel runs as a containerized service in the Docker Compose setup:

- **Port**: 8888 (accessible at http://localhost:8888)
- **Image**: Built from the local `./Sentinel` directory (as there is no official image)
- **Dependency**: Depends on Nacos for service discovery

## Configuration

The application services are configured to connect to the Sentinel dashboard through the following mechanism:

- Services automatically register flow control rules defined in the code
- Dashboard connects to services through their `/actuator/sentinel` endpoints
- Hot-swap of rules is possible through the dashboard interface

## Usage

1. **Access Dashboard**: Visit `http://localhost:8888` after starting the Docker Compose environment
2. **Default Credentials**: Check the Docker Compose file for default login credentials
3. **Monitor Services**: Services will appear in the left navigation panel once connected
4. **Configure Rules**: Set up flow control, circuit breaker, and system rules directly from the UI

## Dependencies

- **Spring Cloud Alibaba**: Provides the integration between Spring Cloud and Sentinel
- **Nacos**: Used for service discovery to locate the services to be protected
- **Docker**: Containerization for the dashboard service

## Building the Docker Image

The custom Docker image is built from the files in the `./Sentinel` directory. To rebuild:

```bash
cd ./Sentinel
docker build -t sentinel-dashboard .
```

## References

- Official Repository: [https://github.com/alibaba/Sentinel](https://github.com/alibaba/Sentinel)
- Sentinel Wiki: [https://github.com/alibaba/Sentinel/wiki](https://github.com/alibaba/Sentinel/wiki)
- Spring Cloud Alibaba: [https://spring.io/projects/spring-cloud-alibaba](https://spring.io/projects/spring-cloud-alibaba)