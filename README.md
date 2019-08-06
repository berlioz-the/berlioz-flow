# Berlioz Flow

## Working on new feature
Create new feature branch:
```
$ berlioz-new-feature-branch.sh myfeature
```

Make commits, push commits:
```
$ berlioz-flow-commit
$ berlioz-quick-dev-commit.sh
```

Push to remote
```
$ berlioz-flow-push
$ berlioz-flow-commit-push
$ berlioz-flow-quick-dev-commit-push
$ berlioz-flow-quick-dev-commit-push-skip-ci
```

When ready merge to staging:
```
$ berlioz-merge-to-staging.sh
$ berlioz-merge-to-staging-and-push.sh
```

Sync from staging to feature branch:
```
$ berlioz-merge-from-staging.sh
```

```
$ berlioz-delete-branch.sh myfeature
```
