Open Dashboards has a DSL for performing searches, e.g.:
source = chq.* | sort - @timestamp |  where  LIKE(message, '%sample text%') = true
