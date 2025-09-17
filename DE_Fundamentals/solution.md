This is a Data solution for Beejan Technologies, designed to build a data flow pipeline for managing customer complaints. This solution aims to collect data from various sources in different formats, integrate, clean, transform, and enrich the data, and make it readily available and easily accessible to downstream users for further decision-making. Below is a step-by-step breakdown to guide the design and building of the data pipeline.
<img width="2480" height="1500" alt="Conceptual_data_pipeline" src="https://github.com/user-attachments/assets/76770659-5aa8-4b85-b8ed-c8092c823732" />

1. Source Identification
* Data Sources: The primary sources of the customer complaints are
** Social Media 
** Call Center Log Files
SMS
Website Forms
Formats: Data is available in different formats, which are
Structured Data: Call Center Log Files are assumed to be CSV.
Semi-Structured Data: SMS, some part of Social Media data and Website forms, which can potentially come in JSON or XML.
Unstructured Data: part of social media (text, images, videos, etc.)
Frequency: Both Batch and Streaming.

Ingestion Strategy
A hybrid approach will be implemented, using Batch and micro-batching. Real-time data sources such as Social Media, SMS and Website Forms that require immediate attention and real-time streaming will be ingested via micro-batching (every 2 - 5 minutes). The reason is to maintain nearly real-time ingestion while being cost-effective. This will involve using API ingestion for social media. Whereas a traditional Batch will be used for Call Center log files via file uploads.

Processing/Transformation
Data Cleaning and Standardisation: This stage focuses on cleaning the data and ensuring it’s in a useful and unified format. Based on assumptions about how the raw data will be, the following can be carried out to ensure it’s clean and standardised.
Enforce the same consistent schema on all data regardless of the source.
Deduplication: This ensures that only one record of the same complaint is kept, as it can be assumed that a single customer may make the same complaint across multiple channels.
Ensuring a uniform format/data type for date and time, phone numbers and even text (i.e making mixed cases into a single case type (e.g lowercase)  across the entire dataset.
Depending on the organisation’s definitions of valuable data, unnecessary data that comes along from api ingestion can be dropped. 
The data can be enriched by adding further information to customers, like their current plan, location, status(e.g a premium subscriber).
In this stage, other forms of transformation can still occur beyond those mentioned above, and all unstructured data will require advanced techniques for processing.
Complaint Category: complaints can be categorised into three groups (Billing, Customer Service and Network) based on keyword matching in complaints.

Storage Options
Both a data lake and a data warehouse will be used as storage. A data lake will hold the raw data once ingested. Processing and transformation of the data also occur here. The transformed data will be loaded into a data warehouse for further use by downstream users.
Reason: A data lake is flexible to store different data formats and types.
The cleaned data will be stored in parquet format. This format allows high compression ratios, which reduces memory cost. Fast data retrieval and query performance are enabled due to its columnar structure. Hence, making this the most efficient format for analytical queries.

Serving
Querying the Data: The data will be queried using SQL directly from the data warehouse
How Downstream Users Use the Data: 
Data analysts will create reports and dashboards from the queried data.
Management will utilise the dashboards to monitor and identify valuable insights, enabling them to make informed strategic decisions.
The pipeline will provide a feed of complaints, enabling the customer service to respond promptly and further resolve the issue.

Orchestration & Monitoring
Pipeline Scheduling: The pipeline will be orchestrated to run at different frequencies daily.
Micro-batching will occur during business hours for real-time sources (social media, sms and website forms).
The batch portion (for call center logs) will run every 2 hours during business hours.
After business hours, batch processing will be scheduled for all data sources that will run overnight.
Failure Detection & Notification: The orchestration system will feature a robust monitoring system that generates detailed logs to track the data flow, and external messaging systems will be utilised to receive alerts on pipepile failure or other issues.

DataOps
The pipeline will run on a cloud-based infrastructure to leverage managed services, ensure scalability, flexibility, global accessibility, reliability and cost efficiency.












