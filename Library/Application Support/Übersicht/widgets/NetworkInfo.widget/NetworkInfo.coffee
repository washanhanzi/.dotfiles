#--------------------------------------------------------------------------------------
# Please Read
#--------------------------------------------------------------------------------------
# The images used in this widget are from the Noun Project (http://thenounproject.com).
#
# They were created by the following individuals:
#   Ethernet by Michael Anthony from The Noun Project
#   Wireless by Piotrek Chuchla from The Noun Project
#
#--------------------------------------------------------------------------------------

# Execute the shell command.
command: "NetworkInfo.widget/NetworkInfo.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 5000

# Render the output.
render: (output) -> """
  <table id='services'></table>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)
  
  # Parse the JSON created by the shell script.
  data = JSON.parse output
  html = ""
  
  # Loop through the services in the JSON.
  for svc in data.service
  
    if svc.ipaddress == ''
      continue

    # Start building our table cell.
    html += "<td class='service'>" 
    html += "<p class='primaryInfo'>" + svc.name + "</p>" 
    # If there is an IP Address, we should show the connected icon. Otherwise we show the disable icon.
    # If there is no IP Address, we show "Not Connected" rather than the missing IP Address.
    html += "<p class='primaryInfo'>" + svc.ipaddress + "</p>" 
    html += "<p class='primaryInfo'>" + svc.router + "</p>" 
    
    # Show the Mac Address.
    # html += "  <p class='secondaryInfo'>" + svc.macaddress + "</p>"
    html += "</td>"
  
  # Set our output.
  $(services).html(html)

# CSS Style
style: """
  margin: 0
  padding: 0px
  right: 10px
  top: 120px
  background:rgba(#000, .25)
  border:1px solid rgba(#000, .25)
  border-radius:10px
      
  .service
    text-align:center
    padding:2px
    color: rgba(255,99,71,0.75)

  .icon
    height:32px
    width:32px
    
  .primaryInfo, .secondaryInfo
    font-family: Helvetica Neue
    padding:0px
    margin:2px
    color: rgba(218,112,214,0.75)
    
  .primaryInfo
    font-size:10pt
    font-weight:bold
    color: rgba(218,112,214,0.75)
    
  .secondaryInfo
    font-size:8pt
    color: rgba(218,112,214,0.75)
"""
