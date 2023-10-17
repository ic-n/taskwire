# taskwire

__([v1 - task automatisation](https://www.linkedin.com/posts/ic-n_ssh-automation-sshclient-activity-6959779086525186048-JBop))__

Taskwire is an SSH client for the automation maintenance of routine tasks. As deploy or database migration. We invest very much in UX research. We are inspired to deliver the best experience and cover all modern developer’s needs. Our target auditory is small startups and freelance developers where developers are doing server administration. The desktop application looks great. Taskwire is written using Flutter (Dart language) and uses Go to do secure SSH keys exchange.

__([v2 - fancy latest version](https://www.linkedin.com/posts/ic-n_taskwire-2-activity-6967183184304197632-CcPs))__

(not posted to this repository, but related)

Application divided into backend and frontend. The backend is written on Go, using mvdan/sh and compiled with CGO. The frontend is written on flutter. It connected to the backend via FFI calls to go so lib. ASCII colour decoding is a great challenge.

Also, there is a custom TUI. You can see it in the demo when I call `~ls` command — there is a special bus between frontend and backend.

Design is a kind of neomorphism.

## Getting Started

Install go and flutter, and go-task to run taskfile

```
task sshtest go flutter
```
