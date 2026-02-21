resource "aws_kinesis_stream" "datacenter_stream" {
    name = "datacenter-stream"

    stream_mode_details {
        stream_mode = "ON_DEMAND"
    }
}