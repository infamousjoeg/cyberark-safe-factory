# CyberArk REST API: From Start-to-Finish Q&A

## Q. Is there a way to determine how many objects are in a safe?

A. You can use the [Get Account Details](https://cybr.rocks/RESTAPIv10#d777b281-01fa-dad5-5cd0-516fdc98dbf5) endpoint introduced in version 9.3 and send no value as the `Keywords` and the safe name as `Safe`.

## Q. What version of the API are these modules based upon?

A. The PowerShell modules work with every version of the REST API, it is a matter of what endpoints were introduced on the version you are on.

## Q. Is it possible to upgrade the API 10.2 framework in our current CyberArk 9.8 infrastructure?

A. No, all relevant components must be on the same version.  Therefore, it would take a complete upgrade to v10.2 to utilize the benefits.

## Q. Do you have instructions on how you find all this code once you install Postman?  Is there a video on how to use Postman?

A. We went over how to utilize Postman during the webinar, so reviewing that on-demand video would be your ticket.  As to instructions on how to find code once you install Postman, you still have to write the code, but you can load the Collection at [https://cybr.rocks/RESTAPIv10](https://cybr.rocks/RESTAPIv10).

## Q. What is the advantage of performing operations via REST API over traditional method?  What are the use cases for REST API and CyberArk integration?

A. The advantage to performing operations via REST API over traditional methods is that a human user is not required to take time out of their busy day to actually make the changes.  As to your second question, I'd ask that you read the README file pspete created at [https://github.com/pspete/psPAS](https://github.com/pspete/psPAS) and take a look at the use cases he's laid out and given examples of.  That should get your gears turning...

## Q. Are all the other default permissions being added to the safe - Master, etc. ?

A. Yes, they are automatically added by default to every safe created regardless of method of creation.  They are just hidden by default from the Safe Membership list.

## Q. This is FANTASTIC!!!! When adding the AD group is SearchIn literally your resolvable domain name, or some type of reference to an LDAP Mapping from PVWA.

A. It's the name that would appear if you were adding the Safe Member from within PVWA and you select `Vault` from the upper-right hand corner dropdown... whatever that label is you select.  Mine was `joe-garcia.local` so I used that.

## Q. In v9.5 & earlier, there is limitation on the service account that could be used for REST access that the account must be a local CyberArk user and the account must be provided with vault ADMINISTRATOR permissions. Does this restriction apply in later versions?

A. No, as of v9.7 and above, we accept LDAP, SAML, RADIUS (username/password, not challenge/response) and Shared Logon Authentication.

## Q. How is AIM licensed for use in scripts? Is it one license per script, one license per host for all scripts on that host, etc...?

A. For the Centralized Credential Provider (CCP) we used in this demonstration, it is licensed by target endpoint.  Therefore, if I was running these scripts off an automation server... it'd be one (1) target endpoint for CCP.  I could have hundreds of scripts on that automation server... still one (1) target endpoint.

## Q. Are there plans about to perform similar meeting about accounts creation automation?

A. We actually did that last year at CyberArk Impact 2017 in the Americas.  We created [Password Upload Utility v2 (PUU2)](https://github.com/infamousjoeg/PasswordUploadUtility-v2) live on stage.  Since then, CyberArk R&D has created a newer version called [Account Onboarding Utility](https://github.com/cyberark/epv-api-scripts/tree/master/Account%20Onboard%20Utility) which is the newest and best way to bulk upload or bulk modify accounts in EPV.  It can also create safes on the fly using a safe template!

## Q. How are creds being used? Is AIM responsible for this to work?

A. Yes, we used CyberArk's Application Identity Manager (AIM) Centralized Credential Provider (CCP) to deliver the credentials securely just-in-time.

## Q. He mentioned earlier about a presentation where he replaced the password bulk import tool and used an api, can I get that link?

A. [Password Upload Utility v2 (PUU2)](https://github.com/infamousjoeg/PasswordUploadUtility-v2)

## Q. Is there a module for Python?

A. Unfortunately, there is not.  However, there is a cool Python CLI tool that was built by a customer in the past that is available on PyPi: [https://github.com/adfinis-sygroup/pyark](https://github.com/adfinis-sygroup/pyark)

Also, there's a neat feature in Postman that allows you to take code snippets of whatever you have in there.  So, you can just take a code snippet of Python Requests and call it a day.  Just don't forget to `pip install requests` first!

## Q. Do we have an example of how do I log into CyberArk via a REST POST call using Java?

A. Sorry, I am not a Java developer.  However, if anyone in the community would like to submit a PR to update this README with the answer, I'd happily accept it!

## Q. Will this .ps1 script allow us to execute via Start-Process and utilize the -RedirectStandardInput with an input file of safe names?

A. This script was meant to be a guide, not a fully polished ready for GA and support type application released from CyberArk.  Use it as a template to learn from and expound upon.  Feel free to fork and go forth!  This was super hard to fit into 45 minutes. :-)

## Q. Can you please go back and show how you got the system account username and password so they didn't need to be hard coded?

A. I've actually made a separate README at [modules/README.md](modules/README.md) that explains this entire process.

## Q. It appears we can use the psPAS PowerShell module to retrieve passwords programatically from CyberArk. Is there any guidance around retrieving passwords this way rather than using AIM and/or CCP to do the same thing?

A. You're welcome to retrieve the credentials in any manner you'd like.  The benefits of retrieving securely via AIM is that we get an audit workflow established that makes sense.  Instead of a random Windows Service Account every where, we can establish an identity with AIM to the Application to make it more relevant to Auditors.  Also, there are multiple factors of authorization AIM utilizes to ensure every request is allowed access to the credentials.

If you retrieve credentials via the REST API, you already need to be logged in and authenticated as a user (so, secret zero becomes a problem again) and you lose all legitimate auditing because you're utilized a random Windows Service Account again.

I would recommend against it.

## Q. Forgot to put EXIT at line 37?

A. Actually, no I didn't.  I want it to proceed.  The assumption was that if there's an error at safe creation, then the safe already exists and we can continue to add safe members.  Therefore, no `Exit` in the `catch {...}`.