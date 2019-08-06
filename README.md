# Berlioz Flow

## Working on new feature
Create new feature branch:
```
$ berlioz-new-feature-branch.sh myfeature
```

Make commits, push commits:
```
$ berlioz-commit.sh
$ berlioz-commit-push.sh
$ berlioz-quick-dev-commit.sh
$ berlioz-quick-dev-commit-skip-ci.sh
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
