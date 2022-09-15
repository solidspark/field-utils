data "honeycombio_query_specification" "refinery-receive-buffers" {
  calculation {
    op     = "SUM"
    column = "incoming_router_dropped"
  }

  calculation {
    op     = "SUM"
    column = "peer_router_dropped"
  }

  breakdowns = ["hostname"]
  time_range = 86400
}

resource "honeycombio_query" "refinery-receive-buffers-query" {
  dataset    = var.refinery_metrics_dataset
  query_json = data.honeycombio_query_specification.refinery-receive-buffers.json
}

resource "honeycombio_query_annotation" "refinery-receive-buffers-query" {
  dataset     = var.refinery_metrics_dataset
  query_id    = honeycombio_query.refinery-receive-buffers-query.id
  name        = "Receive Buffers"
  description = "Look for values above 0. If either metric is consistently above 0, increase CacheCapacity. The receive buffers are consistently three times the size of CacheCapacity."
}