workspace "Amazon Web Services Example" "An example AWS deployment architecture." {

    model {

        discordApi = softwaresystem "Discord API" "External" {
            tags "External"
        }
        twitterApi = softwaresystem "Twitter API" "External" {
            tags "External"
        }

        coreSystem = softwaresystem "Core System" {
            singlePageApplication = container "Single-Page Application" "" "Typescript/Next.js" {
                tags "Application"
            }
            apiApplication = container "API" "" "Typescript/Node.js" {
                tags "Application"
            }
            mongodb = container "NoSQL Database" "" "Mongodb" {
                tags "Database"
            }
            neo4j = container "Graph Database" "" "Neo4j" {
                tags "Database"
            }
            rabbitmq = container "Message Broker" "" "RabbitMQ" {
                tags "Database"
            }
        
            singlePageApplication -> apiApplication "Reads from and writes to" "JSON/HTTPS"
            apiApplication -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            apiApplication -> neo4j "Reads from" "Bolt Protocol/TCP"
            apiApplication -> rabbitmq "Send messages to" "AMQP Protocol/TCP"
        }
            
        discordBotSystem = softwaresystem "Discord Bot" {
            db = container "Application" "" "Typescript/Node.js" {
                tags "Application"
            }
            dbQueue = container "Job Queue" "" "Redis" {
                tags "Database"
            }
                
            rabbitmq -> db "Receives from and sends to" "AMQP Protocol/TCP"
            db -> dbQueue "Reads from and writes to" "RESP Protocol/TCP"
            db -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            db -> discordApi "Reads from and writes to" "JSON/HTTPS"
        }
            
            discordAnalyzerSystem = softwaresystem "Discord Analyzer" {
                das = container "Server" "" "Python" {
                    tags "Application"
                }
                daQueue = container "Job Queue" "" "Redis" {
                    tags "Database"
                }
                daw = container "Worker" "" "Python" {
                    tags "Application"
                }
                
                rabbitmq -> das "Receives from" "AMQP Protocol/TCP"
                das -> daQueue "Reads from and writes to" "RESP Protocol/TCP"
                daQueue -> daw "Reads from and writes to" "RESP Protocol/TCP"
                daw -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
                daw -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"
                daw -> rabbitmq "Sends to" "AMQP Protocol/TCP"
            }
            
            twitterBotSystem = softwaresystem "Twitter Bot" {
                tbs = container "Server" "" "Python" {
                    tags "Application"
                }
                tbQueue = container "Job Queue" "" "Redis" {
                    tags "Database"
                }
                tbw = container "Worker" "" "Python" {
                    tags "Application"
                }
                
                rabbitmq -> tbs "Receives from" "AMQP Protocol/TCP"
                tbs -> tbQueue "Reads from and writes to" "RESP Protocol/TCP"
                tbQueue -> tbw "Reads from and writes to" "RESP Protocol/TCP"
                tbw -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
                tbw -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"
                tbw -> rabbitmq "Sends to" "AMQP Protocol/TCP"
                
                tbw -> twitterApi "Reads from and writes to" "JSON/HTTPS"
            }
    
        monitoringSystem = softwareSystem "Monitoring System" {
            grafana = container "Grafana"
            loki = container "Loki"
            prometheus = container "Prometheus" "Metrics Data"
            cadvisor = container "cAdvisor" "Container Metrics"
            nodeExporter = container "Node Exporter" "Node Metrics"
    
            grafana -> prometheus "Reads from" "PromQL"
            grafana -> loki "Reads from"
            prometheus -> cadvisor "Uses"
            prometheus -> nodeExporter "Uses"
            
            loki -> apiApplication "Pulls logs from" "HTTP"
            loki -> mongodb "Pulls logs from" "HTTP"
            loki -> neo4j "Pulls logs from" "HTTP"
            loki -> rabbitmq "Pulls logs from" "HTTP"
            loki -> db "Pulls logs from" "HTTP"
            loki -> dbQueue "Pulls logs from" "HTTP"
            loki -> das "Pulls logs from" "HTTP"
            loki -> daQueue "Pulls logs from" "HTTP"
            loki -> daw "Pulls logs from" "HTTP"
            loki -> tbs "Pulls logs from" "HTTP"
            loki -> tbQueue "Pulls logs from" "HTTP"
            loki -> tbw "Pulls logs from" "HTTP"
            
            prometheus -> apiApplication "Pulls metrics from" "HTTP"
            prometheus -> mongodb "Pulls metrics from" "HTTP"
            prometheus -> neo4j "Pulls metrics from" "HTTP"
            prometheus -> rabbitmq "Pulls metrics from" "HTTP"
            prometheus -> db "Pulls logs metrics" "HTTP"
            prometheus -> dbQueue "Pulls metrics from" "HTTP"
            prometheus -> das "Pulls metrics from" "HTTP"
            prometheus -> daQueue "Pulls metrics from" "HTTP"
            prometheus -> daw "Pulls metrics from" "HTTP"
            prometheus -> tbs "Pulls metrics from" "HTTP"
            prometheus -> tbQueue "Pulls metrics from" "HTTP"
            prometheus -> tbw "Pulls metrics from" "HTTP"
        }

        production = deploymentEnvironment "Production" {

            deploymentNode "Administrator" {
                mongodbCompass = infrastructureNode "MongoDB Compass"
                neo4jDesktop = infrastructureNode "Neo4j Desktop"
                browser = infrastructureNode "Web Browser"
            }

            deploymentNode "Cloudflare" {
                dns = infrastructureNode "DNS"
            }
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"
                region = deploymentNode "EU-Central-1" {
                    tags "Amazon Web Services - Region"
                    deploymentNode "Amazon EC2" "" "r5.large" {
                        tags "Amazon Web Services - EC2"

                        deploymentNode "Application Services" "" "Docker Compose" {

                            apiApplicationInstance = containerInstance apiApplication {
                                tags "Docker Container"
                            }
                            mongodbInstance = containerInstance mongodb {
                                tags "Docker Container"
                            }
                            neo4jInstance = containerInstance neo4j {
                                tags "Docker Container"
                            }
                            rabbitmqInstance = containerInstance rabbitmq {
                                tags "Docker Container"
                            }

                            # discordBotSystemInstance = softwareSystemInstance discordBotSystem
                            discordBotInstance = containerInstance db {
                                tags "Docker Container"
                            }
                            discordBotQueueInstance = containerInstance dbQueue {
                                tags "Docker Container"
                            }
                            
                            # discordAnalyzerSystemInstance = softwareSystemInstance discordAnalyzerSystem
                            discordAnalyzerServerInstance = containerInstance das {
                                tags "Docker Container"
                            }
                            discordAnalyzerQueueInstance = containerInstance daQueue {
                                tags "Docker Container"
                            }
                            discordAnalyzerWorkerInstance = containerInstance daw {
                                tags "Docker Container"
                            }
                            
                            # twitterBotSystemInstance = softwareSystemInstance twitterBotSystem
                            twitterBotServerInstance = containerInstance das {
                                tags "Docker Container"
                            }
                            twitterBotQueueInstance = containerInstance daQueue {
                                tags "Docker Container"
                            }
                            twitterBotWorkerInstance = containerInstance daw {
                                tags "Docker Container"
                            }
                            
                        }

                        deploymentNode "Monitoring Services" "" "Docker Compose" {
                            # monitoringSystemInstance = softwareSystemInstance monitoringSystem

                            grafanaInstance = containerInstance grafana {
                                tags "Docker Container"
                            }

                            lokiInstance = containerInstance loki {
                                tags "Docker Container"
                            }
                            prometheusInstance = containerInstance prometheus {
                                tags "Docker Container"
                            }
                            cadvisorInstance = containerInstance cadvisor {
                                tags "Docker Container"
                            }
                            nodeExporterInstance = containerInstance nodeExporter {
                                tags "Docker Container"
                            }
                        }
                    }
                }
            }
            
            dns -> apiApplicationInstance "Forwards requests to" "HTTPS"
            browser -> grafanaInstance "Make requests to" "HTTP"
            mongodbCompass -> mongodbInstance "Make requests to" "Wire Protocol/TCP"
            neo4jDesktop -> neo4jInstance "Make requests to" "Bolt Protocol/TCP"
        }

    }

    views {
        deployment * "Production" "ProductionDeployment" {
            include *
            # exclude "* -> *"
            autolayout
        }
        
        systemLandscape "TogetherCrewLandscape" {
            include *
            autolayout
        }
        
        container coreSystem "CoreSystemContainer" {
            include *
            exclude monitoringSystem
            autolayout
        }
        
        container discordBotSystem "DiscordBotSystemContainer" {
            include db dbQueue discordApi rabbitmq mongodb 
            exclude monitoringSystem
            autolayout
        }
        
        container discordAnalyzerSystem "DiscordAnalyzerSystemContainer" {
            include das daQueue daw rabbitmq mongodb neo4j
            exclude monitoringSystem
            autolayout
        }
        
        container twitterBotSystem "TwitterBotSystemContainer" {
            include tbs tbQueue tbw rabbitmq mongodb neo4j
            exclude monitoringSystem
            autolayout
        }
        
        container monitoringSystem "MonitoringSystemContainer" {
            include *
            exclude monitoringSystem
            autolayout
        }

        systemContext coreSystem "CoreSystemContext" {
            include *
            autolayout
        }

        systemContext discordBotSystem "DiscordBotSystemContext" {
            include *
            autolayout
        }

        systemContext discordAnalyzerSystem "DiscordAnalyzerSystemContext" {
            include *
            autolayout
        }

        systemContext twitterBotSystem "TwitterBotSystemContext" {
            include *
            autolayout
        }

        systemContext monitoringSystem "MonitoringSystemContext" {
            include *
            autolayout
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "User" {
                background #08427b
            }
            element "Engineer" {
                background #999999
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
            }
            element "Database" {
                shape Cylinder
            }
            element "Message Bus" {
                shape Pipe
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }
            element "Target" {
                opacity 50
            }
            element "Docker Container" {
                icon "https://i.ibb.co/QchqCW6/docker.png"
            }
        }

        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }

}