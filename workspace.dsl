workspace {

    model {
        user = person "User" "A community manager"
        engineer = person "Engineer" "A TogetherCrew engineer"
        
        discord = softwareSystem "Discord API" "" "External"
        twitter = softwareSystem "Twitter API" "" "External"
        
        group "TogetherCrew" {
        
            softwareSystem = softwareSystem "TogetherCrew System" {
        
                frontend = container "frontend" "Typescript and Next.js"
                api = container "api" "Typescript and Express.js"
                rabbitmq = container "RabbitMQ" "Message broker"

                mongodb = container "MongoDB" "Account and analytics data" {
                    tags "Database"
                }
                neo4j = container "Neo4j" "Analytics data" {
                    tags "Database"
                }

                discordBot = container "Discord bot" "Javascript"
                discordAnalyzer = container "Discord analyzer" "Python"

                twitterBot = container "Twitter bot" "Python" {
                    tags "Target"
                }
                twitterAnalyzer = container "Twitter analyzer" "Python" {
                    tags "Target"
                }
            }
            
            # relationship between people and software systems
            user -> softwareSystem "View metrics, configure settings"
            softwareSystem -> discord "Makes API calls to" "JSON/HTTPS"
            
            # relationships to/from containers
            user -> frontend "Visits app.togethercrew.com using" "HTTPS"
            frontend -> api "Makes API calls to" "JSON/HTTPS"
            api -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            api -> neo4j "Reads from" "Bolt Protocol/TCP" "Target"
            api -> rabbitmq "Emits and listens to events using" "AMQP"

            discordBot -> rabbitmq "Emits and listens to events using" "AMQP"
            discordBot -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            discordBot -> discord "Makes API calls to" "JSON/HTTPS"

            discordAnalyzer -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            discordAnalyzer -> rabbitmq "Emits and listens to events using" "AMQP"
            discordAnalyzer -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"
            
            twitterBot -> rabbitmq "Emits and listens to events using" "AMQP"
            # twitterBot -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            twitterBot -> twitter "Makes API calls to" "JSON/HTTPS"

            # twitterAnalyzer -> mongodb "Reads from and writes to" "Wire Protocol/TCP"
            twitterAnalyzer -> rabbitmq "Emits and listens to events using" "AMQP"
            twitterAnalyzer -> neo4j "Reads from and writes to" "Bolt Protocol/TCP"

        }

        group "Monitoring" {
            monitoringSystem = softwareSystem "Monitoring System" {
                grafana = container "Grafana" "Dashboard"
                loki = container "Loki" "Log Data"
                prometheus = container "Prometheus" "Metrics Data"
                cadvisor = container "cAdvisor" "Container Metrics"
                nodeExporter = container "Node Exporter" "Node Metrics"
                stateExporter = container "Docker State Exporter" "Container States" {
                    tags "Target"
                }
            }

            engineer -> monitoringSystem "View logs and metrics"

            engineer -> grafana "Visits ... using" "HTTPS"
            grafana -> prometheus "Reads from"
            grafana -> loki "Reads from"
            prometheus -> cadvisor "Uses"
            prometheus -> nodeExporter "Uses"
            prometheus -> stateExporter "Uses"
        }
    }

    views {
    
        systemContext softwareSystem "SystemContext" {
            include *
            autoLayout
        }

        container softwareSystem {
            include *
            autoLayout
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
            element "Customer" {
                background #08427b
            }
            element "Bank Staff" {
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