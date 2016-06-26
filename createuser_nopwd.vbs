Dim strUser : strUser = "nopwdvbs"
Dim objRootLDAP : Set objRootLDAP = GetObject("LDAP://rootDSE")
Dim objContainer : Set objContainer = GetObject("LDAP://cn=Users," & objRootLDAP.Get("defaultNamingContext")) 
Dim objUser : Set objUser = objContainer.Create("User","cn=" & strUser)
objUser.Put "sAMAccountName",strUser
objUser.Put "givenName",strUser
objUser.SetInfo
objUser.AccountDisabled = False
objUser.SetInfo
objUser.SetPassword ""
objUser.SetInfo
Set objUser = Nothing
Set objContainer = Nothing
Set objRootLDAP = Nothing