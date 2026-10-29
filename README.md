# Introduction to TrueSource by Broadcom

Take this course on Spring Academy at the link below:

[https://spring.academy/courses/truesource-intro](https://spring.academy/courses/truesource-intro)

## Repository layout

| Path | Contents |
|---|---|
| `metadata/lms/` | Course, module, and lesson metadata for `penguinctl` (`make deploy-lms`) |
| `labs/anchor/` | The Educates Markdown lab (`spring-anchor`): pages in `workshop/content/`, session setup in `workshop/setup.d/` |
| `resources/` | Educates `Workshop` and `TrainingPortal` resources, applied by the workshop puller, plus per-environment values |
| `scripts/build-spring-enterprise-repo.sh` | Builds the pre-staged Spring Enterprise artifacts the lab uses (needs a Spring Enterprise token) |
| `run-lab-locally.sh` | Runs the lab locally with the `educates` CLI |

## Lab prerequisites

The lab downloads two artifacts from the `academy-artifacts` bucket with initContainers, using the `gcp` bucket reader secret that the `SecretCopier` copies from the `spring-academy` namespace:

* `spring/binaries/application-advisor-cli-linux/application-advisor-cli-linux-1.6.7.tar` (shared with the Spring Academy App Advisor guide)
* `spring/anchor/spring-enterprise-repo-boot-3.5.17.tar.gz`, built with `scripts/build-spring-enterprise-repo.sh`

> The Spring Enterprise archive was last built on 2026-10-12. Building it needs a personal Spring Enterprise token, and moving that to a workflow is tracked in [#1](https://github.com/spring-academy/course-anchor-truesource/issues/1).

## Build and deploy

* `make build BUILDER=local` builds the lab image locally.
* Pushes to `main` build and publish the image tagged with the commit SHA.
* Publishing a GitHub release builds and publishes the image tagged with the release.
* **Deploy Release to Staging** and **Deploy Release to Production** (manual `workflow_dispatch`, run against a release tag) retag the image for the environment and apply the LMS metadata with `penguinctl`.
