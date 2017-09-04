# Semaphore CLI

[![Build Status](https://semaphoreci.com/api/v1/renderedtext/cli/branches/master/badge.svg)](https://semaphoreci.com/renderedtext/cli)
[![Gem Version](https://badge.fury.io/rb/sem.svg)](https://badge.fury.io/rb/sem)

![Semaphore logo](https://d1dkupr86d302v.cloudfront.net/assets/application_bootstrap/layout/semaphore-logo-a6d954e176b6975b511f314a0cc808dc94a8030210077e3a6e904fbe69dc5354.svg)

__Note: This tool is still in the early phase of development.__

The Semaphore CLI is used to manage Semaphore projects from the command line.

For more info about Semaphore see <https://www.semaphoreci.com>

## Semaphore Resource Name (SRN)

SRN is a way of identifying Semaphore resources. This CLI uses SRNs as arguments
for all actions.

Formats for individual resources are the following:

- Organization: `organization_name`
- Team: `organization_name/team_name`
- Project: `organization_name/project_name`
- Shared Configuration: `organization_name/shared_configuration_name`

## Using custom API URL

Create a file at `~/.sem/api_url` containing only the custom url.

## Issues

For problems directly related to the CLI, [add an issue on GitHub](https://github.com/renderedtext/cli/issues/new).

For other issues, [submit a support ticket](https://semaphoreci.com/support).

[Contributors](https://github.com/renderedtext/cli/contributors).

## Developing

Developing the CLI locally requires Ruby.

While developing please follow the [CLI development guide](guides.md).

To run the CLI locally, use the `bundle exec sem`.
