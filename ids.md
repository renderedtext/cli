# IDs in the CLI

Computers like to work with long IDs, but humans are much more comfortable with
hierarchical identifiers. A good example is git. While you could in theory do
everything with SHAs, the git interface allows you to work with labels such as
`master`, `HEAD`, `HEAD^2`, etc...

Semaphore exposes resources and uses UUIDs to uniquely identify resources. This
is very clean when it comes to the API interface, but it is a struggle to work
with from the CLI. For each step you must list the resources, find out their
ids, and then gather any useful information from them.

As an example, let's consider looking up the state of the last build on the
master branch for the test-boosters project. To achieve this, a user would need
to look up several IDS:

``` txt
$ sem orgs

931b14f7-0631-47a7-bb30-58b1c794e62c renderedtext
68ce72af-5725-4c04-af74-5f6ecc9f5e9a renderedtext-playground


$ sem projects --org-id 931b14f7-0631-47a7-bb30-58b1c794e62c

331b14f7-0631-47a7-bb30-58b1c794e62c test-boosters
68ce72af-5725-4c04-af74-5f6ecc9f5e9a semaphore-blog


$ sem branches --project-id 331b14f7-0631-47a7-bb30-58b1c794e62c

531b14f7-0631-47a7-bb30-58b1c794e62c master
98ce72af-5725-4c04-af74-5f6ecc9f5e9a rspec-test
78ce99af-5725-4c04-abas-5f6ecc9f5e9a development


$ sem builds --branch-id 531b14f7-0631-47a7-bb30-58b1c794e62c

531b14f7-0631-47a7-bb30-58b1c794e62c #9901
98ce72af-5725-4c04-af74-5f6ecc9f5e9a #9090
78ce99af-5725-4c04-abas-5f6ecc9f5e9a #9089


$ sem builds:info 531b14f7-0631-47a7-bb30-58b1c794e62c

531b14f7-0631-47a7-bb30-58b1c794e62c #9901 PASSED
```

This is clearly inefficient, and requires many hops from the user. The user
already knows the following information `renderedtext/test-boosters/master` but
he doesn't have a good way to tell this information to the semaphore CLI
efficiently.

A better interface would be:

```
$ sem builds renderedtext/test-boosters/master

531b14f7-0631-47a7-bb30-58b1c794e62c #9901 PASSED
98ce72af-5725-4c04-af74-5f6ecc9f5e9a #9090 FAILED
```

But for this, we need to have a good way to identify and transmit hierarchical
information to the CLI. The CLI itself can make multiple calls to the API to
collect this information.

This is not a finished proposal, only an intro for further thinking.

My current best ideas are to use `/` to pass the hierarchical information, but
this has its downsides.

Other ideas is to look into ARN(amazon resource names) and maybe collect some
good ideas. That way, we could formalize this format and introduce SRN(semaphore
resource names) or SRI(semaphore resource identifiers).
