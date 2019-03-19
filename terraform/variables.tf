variable "cache_control" {
  description = "(Optional) Cache-Control directive to specify caching behavior of object data. If omitted and object is accessible to all anonymous users, the default will be public, max-age=3600"
  default     = ""
}
