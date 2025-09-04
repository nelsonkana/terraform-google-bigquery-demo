module "bq_dataset" {
  source      = "github.com/nelsonkana/terraform-google-bigquery?ref=v1.0.0"
  project_id  = var.project_id
  dataset_id  = "analytics_${var.env}"
  location    = "US"
  description = "Analytics dataset for ${var.env}"
  tables = {
    events = {
      schema = [
        { name = "event_id", type = "STRING", mode = "REQUIRED" },
        { name = "timestamp", type = "TIMESTAMP", mode = "REQUIRED" },
        { name = "user_id", type = "STRING", mode = "NULLABLE" }
      ]
    }
  }
}
