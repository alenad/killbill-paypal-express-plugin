killbill-paypal-express-plugin
==============================

Plugin to use [PayPal Express Checkout](https://www.paypal.com/webapps/mpp/express-checkout) as a gateway.

Release builds are available on [Maven Central](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.kill-bill.billing.plugin.ruby%22%20AND%20a%3A%22paypal-express-plugin%22) with coordinates `org.kill-bill.billing.plugin.ruby:paypal-express-plugin`.

Kill Bill compatibility
-----------------------

| Plugin version | Kill Bill version |
| -------------: | ----------------: |
| 2.x.y          | 0.14.z            |

Requirements
------------

The plugin needs a database. The latest version of the schema can be found [here](https://github.com/killbill/killbill-paypal-express-plugin/blob/master/db/ddl.sql).

Configuration
-------------

```
curl -v \
     -X POST \
     -u admin:password \
     -H 'X-Killbill-ApiKey: bob' \
     -H 'X-Killbill-ApiSecret: lazar' \
     -H 'X-Killbill-CreatedBy: admin' \
     -H 'Content-Type: text/plain' \
     -d ':paypal_express:
  :signature: "your-paypal-signature"
  :login: "your-username-facilitator.something.com"
  :password: "your-password"
  # Switch to false for production
  :test: true' \
     http://127.0.0.1:8080/1.0/kb/tenants/uploadPluginConfig/killbill-paypal-express
```

Usage
-----

Issue the following call to generate a Paypal token:

```
curl -v \
     -X POST \
     -H "Content-Type: application/json" \
     --data-binary '{
       "kb_account_id": "13d26090-b8d7-11e2-9e96-0800200c9a66",
       "currency": "USD",
       "options": {
         "return_url": "http://www.google.com/?q=SUCCESS",
         "cancel_return_url": "http://www.google.com/?q=FAILURE",
         "billing_agreement": {
           "description": "Your subscription"
         }
       }
     }' \
     "http://$HOST:8080/plugins/killbill-paypal-express/1.0/setup-checkout"
```

Kill Bill will return a 302 Found on success. The customer should be redirected to the url specified in the Location header, e.g. https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-20G53990M6953444J.

Once the customer comes back from the PayPal flow, save the BAID in Kill Bill:

```
curl -v \
     -X POST \
     -H "Content-Type: application/json" \
     -H "X-Killbill-CreatedBy: Web server" \
     -H "X-Killbill-Reason: New account" \
     --data-binary '{
       "pluginName": "killbill-paypal-express",
       "pluginInfo": {
         "properties": [{
           "key": "token",
           "value": "20G53990M6953444J"
         }]
       }
     }' \
     "http://$HOST:8080/1.0/kb/accounts/13d26090-b8d7-11e2-9e96-0800200c9a66/paymentMethods?isDefault=true"
```

To display the payment method details for that account, one can call:

```
curl -v \
     "http://$HOST:8080/1.0/kb/accounts/13d26090-b8d7-11e2-9e96-0800200c9a66/paymentMethods?withPluginInfo=true"
```
