# Interface

## Login

```
$ sem login

Username: peter
Password: ***
Two-Factor Auth: 888999

User peter succesfully signed in.
```

## Status

```
$ sem

 [PASSED] renderedtext/cli
 [FAILED] renderedtext/api
[RUNNING] renderedtext/client
 [PASSED] renderedtext/semaphore-docs-new

```

## Help

```
$ sem help
Usage: heroku COMMAND

  login           - Login with your Semaphore credentials
  projects        - Manage semaphore projects
  orgs            - Manage sempahore organizations
  teams           - Manage sempahore teams
  servers         - Manage deployment servers
  shared-configs  - Manage shared configurations
  branches        - Manage branches
  builds          - Manage builds
  deploys         - Manage deploys
  ssh             - Manage SSH sessions

For help for submoands type sem help COMMAND.
```

## Organizations

```
$ sem help orgs

  orgs                                - List your organizations on Semaphore
  orgs:info [--org-username USERNAME] - Get detailed information about an organization
```

## Teams

```
$ sem help teams

  teams                     - List teams where you are a member
  teams:info [--team-id ID] - Get detailed information about a team
  teams:create [ORG]        - Get detailed information about a team

  teams:add_members --team-id [team_id] [usernames] - Add new members to the team
  teams:remove_members [--team-id ID] [usernames]   - Remove users from a team

  teams:add_projects [--team-id ID] [project-ids]     - Add projects to a team
  teams:remove_projects [--team-id ID] [projects-ids] - Remove projects from a team
```
