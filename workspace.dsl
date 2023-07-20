workspace {

    model {
        user = person "User" "A community manager"
        engineer = person "Engineer" "A TogetherCrew engineer"
        
        discord = softwareSystem "Discord API" "" "External"
        twitter = softwareSystem "Twitter API" "" "External"

        
        group "TogetherCrew" {

            togetherCrewSystem = softwareSystem "Together Crew System" {
                frontend = container "frontend" "Typescript and Next.js" {
                    tags "Web Browser"
                }
                
                api = container "api" "Typescript and Express.js"

                rabbitmq = container "RabbitMQ" "Message broker" {
                    tags "Message Bus"
                }
                mongodb = container "MongoDB" "Account and analytics data" {
                    tags "Database"
                }
                neo4j = container "Neo4j" "Analytics data" {
                    tags "Database"
                }
                discordBotContainer = container "Discord Bot" {
                    discordBot = component "Discord Bot" "Typescript"
                    discordBotRedis = component "Discord Bot Redis" {
                        tags "Database"
                    }
                    discordBot -> discordBotRedis
                }

                    
                discordAnalyzerContainer = container "Discord Analyzer" {
                    discordAnalyzerServer = component "Discord Analyzer Server" "Python"
                    discordAnalyzerWorker = component "Discord Analyzer Worker" "Python"
                    discordAnalyzerRedis = component "Discord Analyzer Redis" {
                        tags "Database"
                    }
                    discordAnalyzerServer -> discordAnalyzerRedis
                    discordAnalyzerWorker -> discordAnalyzerRedis
                }

                twitterBotContainer = container "Twitter Bot" {
                    twitterBotServer = component "Twitter Bot Server" "Python"
                    twitterBotWorker = component "Twitter Bot Worker" "Python"
                    twitterBotRedis = component "Twitter Bot Redis" {
                        tags "Database"
                    }
                    twitterBotServer -> twitterBotRedis
                    twitterBotWorker -> twitterBotRedis
                }

                twitterAnalyzerContainer = container "Twitter Analyzer" {
                    twitterAnalyzerServer = component "Twitter Analyzer Server" "Python"
                    twitterAnalyzerWorker = component "Twitter Analyzer Worker" "Python"
                    twitterAnalyzerRedis = component "Twitter Analyzer Redis" {
                        tags "Database"
                    }
                    twitterAnalyzerServer -> twitterAnalyzerRedis
                    twitterAnalyzerWorker -> twitterAnalyzerRedis
                }
            }

            # relationship between people and software systems
            user -> togetherCrewSystem "View metrics, configure settings"
            togetherCrewSystem -> discord "Makes API calls to" "JSON/HTTPS"
            
            # relationships to/from containers
            user -> frontend "Visits app.togethercrew.com using" "HTTPS"
            frontend -> api "Makes API calls to" "JSON/HTTPS"
            api -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            api -> neo4j "Reads from" "Bolt Protocol/TCP" "Target"
            api -> rabbitmq "Emits and listens to events using" "AMQP"

            discordBot -> rabbitmq "Emits and listens to events using" "AMQP"
            discordBot -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            discordBot -> discord "Makes API calls to" "JSON/HTTPS"

            discordAnalyzerServer -> rabbitmq "Listens to events using" "AMQP"
            discordAnalyzerWorker -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            discordAnalyzerWorker -> rabbitmq "Emits to events using" "AMQP"
            discordAnalyzerWorker -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"
            
            twitterBotServer -> rabbitmq "Emits and listens to events using" "AMQP"
            twitterBotWorker -> rabbitmq "Emits and listens to events using" "AMQP"
            twitterBotWorker -> twitter "Makes API calls to" "JSON/HTTPS"
            twitterBotWorker -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"

            twitterAnalyzerServer -> rabbitmq "Emits and listens to events using" "AMQP"
            twitterAnalyzerWorker -> rabbitmq "Emits and listens to events using" "AMQP"
            twitterAnalyzerWorker -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"
        
        }

        group "Monitoring" {
            monitoringSystem = softwareSystem "Monitoring System" {
                grafana = container "Grafana" "Dashboard"
                loki = container "Loki" "Log Data"
                prometheus = container "Prometheus" "Metrics Data"
                cadvisor = container "cAdvisor" "Container Metrics"
                nodeExporter = container "Node Exporter" "Node Metrics"
            }

            engineer -> monitoringSystem "View logs and metrics"

            engineer -> grafana "Visits ... using" "HTTPS"
            grafana -> prometheus "Reads from"
            grafana -> loki "Reads from"
            prometheus -> cadvisor "Uses"
            prometheus -> nodeExporter "Uses"
        }
    }

    views {
    
        systemContext togetherCrewSystem "SystemContext" {
            include *
            autoLayout
        }

        container togetherCrewSystem {
            include *
            autoLayout
        }

        component discordBotContainer "DiscordBot" {
            include *
            # autoLayout
        }

        component discordAnalyzerContainer "DiscordAnalyzer" {
            include *
            # autoLayout
        }

        component twitterBotContainer "TwitterBot" {
            include *
            # autoLayout
        }

        component twitterAnalyzerContainer "TwitterAnalyzer" {
            include *
            # autoLayout
        }

        systemContext monitoringSystem "MonitoringContext" {
            include *
            autoLayout
        }

        container monitoringSystem {
            include *
            autoLayout
        }
        
        theme default
        
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
        }
    }
    
}