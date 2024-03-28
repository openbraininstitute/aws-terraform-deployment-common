# Domains

Contains the domain names, managed by AWS route 53

Originally the name was going to be Swiss Brain Observatory. Then it became Open Brain Platform. Now (March 2024) it has to be renamed to Open Blue Brain, at least during 2024.

This module creates route53 domains for:
* openbluebrain.ch
* openbluebrain.com

For each domain, the module creates an A record which points to the
public load balancer and a CNAME record for www.<domainname> which points
to the hostname without the www prefix.
