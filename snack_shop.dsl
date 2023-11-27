workspace {
    model {
        user = person "Customers" "New or returning Snack Shop Customers"

        group "Snack Shop" {

            snackStaff = person "Snack Shop Staff" "Staff who keep the Snack Shop running to delicious effect"

            storeFront = softwareSystem "Store Front" "Allows customers to place and track orders for tasty treats" {
                group "Web" {
                    singlePageApplication = container "Single-Page Application" "Displays the range of available snacks" "React" {
                        brandColours = component "Brand Colours" "Constants that define all 50 shades pink approved for brand use" "CSS, Tailwind"
                        snackCatalog = component "Snack Catalog" "Make sure each snack is looking its best" "React Component"
                        salesTurbo = component "Sales Turbo" "Makes items on sale really pop" "JavaScript"
                        clickMonkey = component "Click Monkey" "Track user behavior to appease marketing team" "JavaScript"
                    }
                    storeWebBFF = container "Store Web BFF" "Connects web applications to the backend services" "JavaScript and Node"
                }
                group "Mobile" {
                    mobileApplication = container "Mobile Application" "Allows snacks to be viewed on mobile phones" "React Native"
                    storeMobileBFF = container "Store Mobile BFF" "Connects  mobile applications to the backend services" "JavaScript and Node"

                }
            }
        
            customerOrders = softwareSystem "Customer Orders" "Keeps track of all new and historical orders from purchase to dispatch" {
                newOrdersService = container "New Orders Service" "Allows creation of new customer orders"
                orderTrackingService = container "Order Tracking Service" "Keeps track of live and historical orders"
                oldOrderRemovalService = container "Old Order Removal Service" "Makes sure very old orders are deleted to safe space"
                orderRepository = container "Order Repository" "Manages all database interactions"
                ordersDatabase = container "Orders Database" "Stores customer orders"
                legacyOrdersDatabase = container "Legacy Orders Database" "Archive of orders from before 2018"
            }
        
            warehouseLogistics = softwareSystem "Warehouse Logistics" "Manages all deliveries and stock"
        }

        group "Logging Platform" {
            loggingPlatform = softwareSystem "Logging Platform" "Store and dashboard system logs to enable observability"
        }

        group "Delivery Co" {
            deliveryCo = softwareSystem "Delivery Co" "Partner delivery company who collects and delivers orders from warehouse"
        }

        # Relationships between the user and the store front
        user -> storeFront "Browse and purchase snacks"
        user -> mobileApplication "Purchase snacks"
        user -> singlePageApplication "Purchase snacks"

        # Relationships between the components of the store front

        brandColours -> snackCatalog "Display snacks in brand colours"
        salesTurbo -> brandColours "Add highlight for sales items"
        clickMonkey -> storeWebBFF "Send click data"
        snackCatalog -> storeWebBFF "Add, remove and checkout snacks"

        singlePageApplication -> storeWebBFF "Create order"
        storeWebBFF -> newOrdersService "Raises order"

        mobileApplication -> storeMobileBFF "Create order"
        storeMobileBFF -> newOrdersService "Raises order"


        # Relationships between systems
        customerOrders -> warehouseLogistics "Requests stock allocation"
        warehouseLogistics -> deliveryCo "Provide list of orders ready for delivery"
        warehouseLogistics -> orderTrackingService "Update order status"

        # Gimmie those snacks
        deliveryCo -> user "Delivers tasty snacks"

        # Orders System Relationships
        newOrdersService -> orderRepository "Store new orders"
        orderTrackingService -> orderRepository "Store order updates"
        oldOrderRemovalService -> orderRepository "Deletes orders"

        # Database
        orderRepository -> ordersDatabase "Read, write, update and delete"
        orderRepository -> legacyOrdersDatabase "Read orders from before 2018"

        # Logging
        customerOrders -> loggingPlatform "Log errors"
        storeFront -> loggingPlatform "Log errors"
        warehouseLogistics -> loggingPlatform "Log errors"
        loggingPlatform -> snackStaff "Send Alerts"
        snackStaff -> loggingPlatform "Read error logs"
    }

    views {
        systemLandscape "SnackShopSystemLandscape" {
            include *
            autoLayout
        }

        systemContext storeFront "StoreFrontContext" {
            include *
            autoLayout
        }

        systemContext customerOrders "CustomerOrdersContext"{
            include *
            autoLayout       
        }

        container customerOrders "CustomerOrderContainers" {
            include *
            autoLayout
        }

        container storeFront "StoreFrontContainers" {
            include *
            autoLayout
        }

        component singlePageApplication "singlePageApplicationComponents" {
            include *
            autoLayout
        }

        systemContext loggingPlatform "LoggingPlatformContext" {
            include *
            autoLayout
        }


    }

}