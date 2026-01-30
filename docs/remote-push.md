# Pushing this repo to a remote

If you want to move this local repository into a new remote (GitHub, GitLab, Bitbucket, etc.), you can:

1. Create a new empty remote repository (no README, no .gitignore).
2. Add that remote to this repo.
3. Push the current branch.

Example (replace with your remote URL):

```bash
git remote add origin git@github.com:YOUR_ORG/number-adventure.git
git push -u origin HEAD
```

If you already have a remote (and want to replace it), remove it first:

```bash
git remote remove origin
git remote add origin git@github.com:YOUR_ORG/number-adventure.git
git push -u origin HEAD
```

If you prefer HTTPS (prompted for credentials or a token):

```bash
git remote add origin https://github.com/YOUR_ORG/number-adventure.git
git push -u origin HEAD
```

After the first push, you can just use:

```bash
git push
```
