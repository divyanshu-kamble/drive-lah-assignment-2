# Distributed Database System

## Transaction

A database transaction is like actions performed, such as adding, changing, or removing data. It's like doing a bunch of things all at once. Transactions are important because they help keep the database organized and make sure everything stays in order, especially when lots of people are using it at the same time.

It's also crucial that if any failure occurs during the transaction, the system should be able to rollback to the initial state.

### ACID Properties

Transactions are defined by their ACID properties, ensuring database consistency even when multiple transactions are executed simultaneously.

#### Atomicity

A transaction is atomic, meaning it either fully completes or does not occur at all. If any part of the transaction fails, the entire transaction is rolled back, and the database reverts to its state before the transaction begins.

#### Consistency

A transaction guarantees that the database transitions from one consistent state to another. Consistency rules, such as primary key and foreign key constraints, must be upheld throughout the transaction.

#### Isolation

Transactions are isolated from each other, ensuring that the intermediate results of one transaction remain invisible to other transactions. This prevents conflicts and creates the illusion that each transaction is executed sequentially, despite potential concurrency.

#### Durability

Once a transaction is committed, its changes to the database become permanent. The system must safeguard committed data against loss due to crashes or system failures.

## Database Storage Models

### Row-based Storage

This model keeps entire rows of data together on a page.

### Columnar Storage

Here, each column's data is stored separately across different pages.

### Use Cases

- Row-based storage works well for everyday transactions (like buying something online) where you need all the info in a row.
- Columnar storage is great for analyzing lots of data (like figuring out sales trends) because it lets you focus on specific columns easily.

### Data Locality

- **Proximity:** Keeping related data together on the disk can speed things up by reducing the need to fetch data from different places and avoiding memory cache misses.
- **Clustering and Compression:** Grouping similar rows together in row-based storage can make it faster to search for a range of values. In columnar storage, using compression methods can save space and make searching quicker too.

## Distributed Database System

A distributed database system is one that stores data across multiple nodes or locations, rather than on a single centralized server. In a distributed database system, data is distributed and replicated across different sites, which improves scalability, availability, and fault tolerance.

### Characteristics of Distributed Database Systems

- **Data Distribution:** Data is spread out across multiple nodes, even in different places, which helps keep the system running even if something goes wrong.
- **Scalability:** These systems can grow by adding more nodes when needed to handle more data or users.
- **Consistency Models:** They use different ways to make sure all the data stays consistent, balancing between always being right, always being available, and always being fast.
- **Replication and Partitioning:** They copy and split up data across nodes to make sure everything keeps running smoothly, even if one node fails.

## Data Distribution

### Partitioning

Partitioning is a database optimization technique. It improves performance and manageability of large tables. By dividing large tables into smaller, more manageable pieces, partitioning improves query performance, as queries can target only the relevant partitions. This approach also simplifies data management tasks such as backup and archiving, making it a crucial strategy for handling extensive datasets efficiently. Partitioning involves dividing a large table into smaller, more manageable pieces, called partitions, within a single database or database server.

### Sharding

Sharding is a data partitioning technique used in distributed systems to split large datasets into smaller, more manageable pieces called shards. It improves the performance and scalability of large datasets in distributed systems, distributes data across multiple nodes or clusters, and reduces query latency by parallelizing operations across shards.

## Concurrency

When multiple transactions execute concurrently in an uncontrolled or unrestricted manner, it might lead to several problems. These problems are called concurrency problems in the database.

### Solving Concurrency Problems with Locking

Shared and exclusive locks are tools used in database systems to manage multiple users accessing data at the same time, ensuring the data remains correct and reliable.

#### Shared Locks ('read locks')

- **Definition:** Allow many users to read the same data at the same time but prevent anyone from changing the data.
- **Purpose:** Ensures that data can be read by multiple users simultaneously without causing problems.
- **Behavior:** 
  - Many users can read the data at the same time.
  - No one can change the data until all readers are done.

#### Exclusive Locks ('write locks')

- **Definition:** Allow only one user to read and change the data, blocking others from accessing it.
- **Purpose:** Makes sure that only one user can make changes to the data at a time, keeping it safe from conflicts.
- **Behavior:** 
  - Only one user can access the data for changes.
  - No other user can read or change the data until the exclusive lock is released.

### Types of Concurrency Control

#### Two-Phase Locking (2PL)

Two-phase locking (2PL) is a concurrency control method used in databases to ensure consistency in transactions and sequence.

- **Growing Phase:** During this phase, transactions acquire locks on resources as needed. However, no locks can be released.
- **Shrinking Phase:** In this phase, transactions release their locks on resources. No new locks can be acquired.

#### Timestamp Concurrency

Timestamp concurrency is a technique used to manage concurrency in databases.

- Every transaction is given a unique timestamp when it starts.
- Transactions are ordered based on their timestamps.
- If two transactions try to access the same data at the same time, the one with the earlier timestamp gets priority.

### Problems in Locks

#### Deadlocks

Deadlocks are a big problem in databases. They happen when transactions are stuck waiting for each other to give up locks on resources.

- **Definition:** Deadlock is when two or more transactions are stuck indefinitely because each one is waiting for the other to release a resource lock.
- **Behavior:** Transactions are waiting for each other in a loop, like a chain. Nobody can move forward because they're all waiting for someone else.
- **Impact:** In a deadlock, none of the transactions involved can move forward or finish. It's like they're all stuck in a traffic jam, unable to get where they need to go.

### Deadlock Prevention

#### Preemptive Approach

If the system sees a potential deadlock, it forcefully takes resources away from some transactions to prevent the deadlock from happening.

#### Non-preemptive Approach

Instead of stopping transactions, the system carefully manages how resources are given out to transactions to avoid deadlock situations.

## Database Replication

Database replication is a technique for maintaining multiple copies of data across different database nodes. It ensures data reliability, fault-tolerance, and improves data accessibility. If one node gets lost or damaged, you can still access the other nodes which contain the same data.

### Types of Replication

#### Synchronous Replication

In synchronous replication, the master waits for confirmation from each replica node that they have written the data. While this approach guarantees strong data consistency, it can potentially introduce higher latency due to waiting times.

#### Asynchronous Replication

Asynchronous replication doesn't require an immediate acknowledgment from the replica nodes. After the master writes the data, the change is sent to replicas, allowing for faster write operations but at the risk of data inconsistency among nodes if a failure occurs before replication.

#### Snapshot Replication

Snapshot replication involves taking a "snapshot" of the data from the master node at a specific point in time and copying that snapshot to the replica nodes. It's more useful in databases where changes are less frequent.

### Master-Standby Replication

Master-Standby replication is a common replication setup where a primary (master) database is replicated to one or more secondary (standby) databases.

To enhance performance and manage load, read queries are offloaded to standby databases. These databases are read-only, suitable for read operations and reporting, which helps balance the load and keeps the master database from becoming a bottleneck.

Write operations are exclusively performed on the master database to maintain data consistency and integrity. Changes are then propagated to the standby databases, keeping them synchronized. In case of a master database failure, standby databases can be promoted to master status. This failover mechanism ensures continuity of service, maintaining high availability and reducing the impact of potential disruptions.

### Multi-Master Replication

Multi-Master replication is a database replication model where multiple databases can perform write operations simultaneously. Each master node replicates its data to every other node.

- **Write Scalability:** Multi-Master replication spreads out write operations across several masters, which boosts the system's ability to handle writes efficiently.
- **Fault Tolerance:** If one master experiences a failure, operations seamlessly transition to the remaining masters.
- **Load Balancing:** Multi-Master replication not only distributes write operations but also balances the load for read operations across multiple databases.

## Caching

For distributed applications that require low latency and scalability, disk-based databases can pose several challenges, including slow processing queries and high costs to scale. A database cache supplements your primary database by removing unnecessary pressure on it.

### Types of Caching

#### Local Caches

- **Definition:** Local caches store frequently accessed data directly within the application's memory space.
- **Performance:** This setup accelerates data retrieval by eliminating the need for network communication when accessing cached data. As data resides within the application itself, retrieval is swift and efficient.
- **Consistency Issues:** Since they operate independently from nodes, it may result in disconnected caches across the system causing inconsistency.

#### Remote Caches

- **Definition:** Remote caches, also known as "side caches," are separate instances dedicated solely to storing cached data in-memory.
- **Performance:** Remote caches offer centralized storage for cached data, typically on dedicated servers
# Distributed Database System

## Transaction

A database transaction is like actions performed, such as adding, changing, or removing data. It's like doing a bunch of things all at once. Transactions are important because they help keep the database organized and make sure everything stays in order, especially when lots of people are using it at the same time.

It's also crucial that if any failure occurs during the transaction, the system should be able to rollback to the initial state.

### ACID Properties

Transactions are defined by their ACID properties, ensuring database consistency even when multiple transactions are executed simultaneously.

#### Atomicity

A transaction is atomic, meaning it either fully completes or does not occur at all. If any part of the transaction fails, the entire transaction is rolled back, and the database reverts to its state before the transaction begins.

#### Consistency

A transaction guarantees that the database transitions from one consistent state to another. Consistency rules, such as primary key and foreign key constraints, must be upheld throughout the transaction.

#### Isolation

Transactions are isolated from each other, ensuring that the intermediate results of one transaction remain invisible to other transactions. This prevents conflicts and creates the illusion that each transaction is executed sequentially, despite potential concurrency.

#### Durability

Once a transaction is committed, its changes to the database become permanent. The system must safeguard committed data against loss due to crashes or system failures.

## Database Storage Models

### Row-based Storage

This model keeps entire rows of data together on a page.

### Columnar Storage

Here, each column's data is stored separately across different pages.

### Use Cases

- Row-based storage works well for everyday transactions (like buying something online) where you need all the info in a row.
- Columnar storage is great for analyzing lots of data (like figuring out sales trends) because it lets you focus on specific columns easily.

### Data Locality

- **Proximity:** Keeping related data together on the disk can speed things up by reducing the need to fetch data from different places and avoiding memory cache misses.
- **Clustering and Compression:** Grouping similar rows together in row-based storage can make it faster to search for a range of values. In columnar storage, using compression methods can save space and make searching quicker too.

## Distributed Database System

A distributed database system is one that stores data across multiple nodes or locations, rather than on a single centralized server. In a distributed database system, data is distributed and replicated across different sites, which improves scalability, availability, and fault tolerance.

### Characteristics of Distributed Database Systems

- Data is spread out across multiple nodes, even in different places, which helps keep the system running even if something goes wrong.
- These systems can grow by adding more nodes when needed to handle more data or users.
- They use different ways to make sure all the data stays consistent, balancing between always being right, always being available, and always being fast.
- They copy and split up data across nodes to make sure everything keeps running smoothly, even if one node fails.


## Data Distribution

### Partitioning

Partitioning is a database optimization technique. It improves performance and manageability of large tables. By dividing large tables into smaller, more manageable pieces, partitioning improves query performance, as queries can target only the relevant partitions. This approach also simplifies data management tasks such as backup and archiving, making it a crucial strategy for handling extensive datasets efficiently. Partitioning involves dividing a large table into smaller, more manageable pieces, called partitions, within a single database or database server.

### Sharding

Sharding is a data partitioning technique used in distributed systems to split large datasets into smaller, more manageable pieces called shards. It improves the performance and scalability of large datasets in distributed systems, distributes data across multiple nodes or clusters, and reduces query latency by parallelizing operations across shards.

## Concurrency

When multiple transactions execute concurrently in an uncontrolled or unrestricted manner, it might lead to several problems. These problems are called concurrency problems in the database.

### Solving Concurrency Problems with Locking

Shared and exclusive locks are tools used in database systems to manage multiple users accessing data at the same time, ensuring the data remains correct and reliable.

#### Shared Locks ('read locks')

- Allow many users to read the same data at the same time but prevent anyone from changing the data. It ensures that data can be read by multiple users simultaneously without causing problems.
What it does
  - Many users can read the data at the same time.
  - No one can change the data until all readers are done.


#### Exclusive Locks ('write locks')

- Allow only one user to read and change the data, blocking others from accessing it, makes sure that only one user can make changes to the data at a time, keeping it safe from conflicts.
What it does
  - Only one user can access the data for changes.
  - No other user can read or change the data until the exclusive lock is released.


### Types of Concurrency Control

#### Two-Phase Locking (2PL)

Two-phase locking (2PL) is a concurrency control method used in databases to ensure consistency in transactions and sequence.

- **Growing Phase:** During this phase, transactions acquire locks on resources as needed. However, no locks can be released.
- **Shrinking Phase:** In this phase, transactions release their locks on resources. No new locks can be acquired.

#### Timestamp Concurrency

Timestamp concurrency is a technique used to manage concurrency in databases.

- Every transaction is given a unique timestamp when it starts.
- Transactions are ordered based on their timestamps.
- If two transactions try to access the same data at the same time, the one with the earlier timestamp gets priority.

### Problems in Locks

#### Deadlocks

Deadlocks are a big problem in databases. They happen when transactions are stuck waiting for each other to give up locks on resources.

- Deadlock is when two or more transactions are stuck indefinitely because each one is waiting for the other to release a resource lock.

- In this the transaction is waiting for another transaction in a loop, like a chain. Nobody can move forward because they're all waiting for someone else.

- In a deadlock, none of the transactions involved can move forward or finish. It's like they're all stuck in a traffic jam, unable to get where they need to go.


### Deadlock Prevention

#### Preemptive Approach

If the system sees a potential deadlock, it forcefully takes resources away from some transactions to prevent the deadlock from happening.

#### Non-preemptive Approach

Instead of stopping transactions, the system carefully manages how resources are given out to transactions to avoid deadlock situations.

## Database Replication

Database replication is a technique for maintaining multiple copies of data across different database nodes. It ensures data reliability, fault-tolerance, and improves data accessibility. If one node gets lost or damaged, you can still access the other nodes which contain the same data.

### Types of Replication

#### Synchronous Replication

In synchronous replication, the master waits for confirmation from each replica node that they have written the data. While this approach guarantees strong data consistency, it can potentially introduce higher latency due to waiting times.

#### Asynchronous Replication

Asynchronous replication doesn't require an immediate acknowledgment from the replica nodes. After the master writes the data, the change is sent to replicas, allowing for faster write operations but at the risk of data inconsistency among nodes if a failure occurs before replication.

#### Snapshot Replication

Snapshot replication involves taking a "snapshot" of the data from the master node at a specific point in time and copying that snapshot to the replica nodes. It's more useful in databases where changes are less frequent.

### Master-Standby Replication

Master-Standby replication is a common replication setup where a primary (master) database is replicated to one or more secondary (standby) databases.

To enhance performance and manage load, read queries are offloaded to standby databases. These databases are read-only, suitable for read operations and reporting, which helps balance the load and keeps the master database from becoming a bottleneck.

Write operations are exclusively performed on the master database to maintain data consistency and integrity. Changes are then propagated to the standby databases, keeping them synchronized. In case of a master database failure, standby databases can be promoted to master status. This failover mechanism ensures continuity of service, maintaining high availability and reducing the impact of potential disruptions.

### Multi-Master Replication

Multi-Master replication is a database replication model where multiple databases can perform write operations simultaneously. Each master node replicates its data to every other node.

Multi-Master replication is a database replication model where multiple databases can perform write operations simultaneously. Each master node replicates its data to every other node.

Multi-Master replication spreads out write operations across several masters, which boosts the system's ability to handle writes efficiently. With multiple masters processing writes simultaneously, the overall write performance is significantly enhanced.

If one master experiences a failure, operations seamlessly transition to the remaining masters.
Multi-Master replication not only distributes write operations but also balances the load for read operations across multiple databases


## Caching

For distributed applications that require low latency and scalability, disk-based databases can pose several challenges, including slow processing queries and high costs to scale. A database cache supplements your primary database by removing unnecessary pressure on it.

### Types of Caching

#### Local Caches

Local caches store frequently accessed data directly within the application's memory space.
This setup accelerates data retrieval by eliminating the need for network communication when accessing cached data. As data resides within the application itself, retrieval is swift and efficient.
Since they operate independently from nodes it may result in disconnected caches across the system causing inconsistency.


#### Remote Caches

Remote caches are separate instances dedicated solely to storing cached data in-memory.
Remote caches offer centralized storage for cached data, typically on dedicated servers. They are commonly built on key/value NoSQL stores like Redis and Memcached.
relying on remote caches may impact latency compared to local caches.
