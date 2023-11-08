############################
Notes for future deployments
############################

*******************************
Wildcard certificate generation
*******************************

We never resolved the problem generating certificates for domains that were part
of the wildcard domain (``*.xchem.diamond.ac.uk``). Although we created a
specific domain (``keycloak.xchem.diamond.ac.uk``) it still did not work.
We need to understand the wildcard certificate problem if we are to do this
again, and expect to be able to use **Keycloak**, and **Squonk**.
