module Logging

  # Constants
  APP = "traderpog"
  ERROR_TYPE = "e"
  WARNING_TYPE = "w"
  INFO_TYPE = "i"
  TRACE_TYPE = "t"

  def internal_log(type, subtype, message)
    full_msg = APP + "|" + type + "|" + subtype + "|"  + Time.now.to_s + "|"  + message
    puts full_msg
  end

  def error_log(subtype, message)
    internal_log(ERROR_TYPE, subtype, message)
  end

  def warning_log(subtype, message)
    internal_log(WARNING_TYPE, subtype, message)
  end

  def info_log(subtype, message)
    internal_log(INFO_TYPE, subtype, message)
  end

  def trace_log(subtype, message)
    internal_log(TRACE_TYPE, subtype, message)
  end

  def create_error(status, calltype, inputs, message)
    full_message = { :calltype => calltype.to_s, :inputs => inputs, :errors => message }
    error_log(status.to_s, full_message.as_json.to_s)
    render :status => status, :json => { :errors => message }
  end
end