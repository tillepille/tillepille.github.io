---
title: "GitOps at Home"
date: 2021-04-07T11:15:20Z
draft: true
---

# Secure GitOps Pipelines selbstgebaut

Die Cloud gibt uns viele Möglichkeiten, schnell neue Infrastrukturkomponenten aufzusetzen. Als Agentur ist es uns wichtig, unabhängig agieren zu können, weswegen wir auf Terraform statt beispielsweise CloudFormation setzen, welches nur für AWS geeignet ist.

Bei einem Kunden haben wir ein Stagingsystem aufgesetzt, was in der Azure Cloud ein AKS-Cluster bereitstellt, um verschiedene Featurebranches parallel testen zu können und, in einer weiteren Iteration, A/B testing zu ermöglichen.
Wir haben die benötigte Infrastruktur mit Terraform abgebildet weil dies uns einige Vorteile verschafft: 
- Die Umgebung kann nachts oder am Wochenende heruntergefahren werden und durch die Pipeline neu erstellt werden, um Kosten zu sparen.
- Eine gleiche Umgebung, zum Beispiel eine Produktionsumgebung, kann ohne großen Aufwand parallel erzeugt werden.
- Probleme durch manuelle Konfiguration und "zusammenklicken" werden ausgeschlossen.

Dabei werden durch Terraform alle notwendigen, sicherheitsrelevanten Komponenten generiert, zum Beispiel Datenbankpasswörter und Zertifikate und natürlich das Kubernetes Cluster.

Doch wie finden nun all diese Variablen den Weg zurück in die Pipelines derer Services, die eigentlich auf dem Cluster deployed werden sollen? Und das auch noch geschützt vor neugierigen Augen?

**GitOps** ist das Stichwort.

In der Pipeline zur Clustererstellung läuft folgendes Script:

<script src="https://gist.github.com/tillepille/90f2fba83db04a3c550889bd72f45a7d.js"></script>

## TL;DR

Das Skript klont die angegebenen Repositories, ersetzt die Werte in den JSON Dateien durch die aktuellen Werte (Zeile [76](https://gist.github.com/tillepille/90f2fba83db04a3c550889bd72f45a7d#file-infra-gitops-sh-L76), [4](https://gist.github.com/tillepille/90f2fba83db04a3c550889bd72f45a7d#file-infra-gitops-sh-L4)) und eröffnet über die git push options ein Merge Request in den entsprechenden App-Repositories.

## TC;DU

*too complicated, didn't understand*

Da es sich um sicherheitsrelevante Daten handelt, haben wir die entsprechenden Dateien mit [sops](https://github.com/mozilla/sops) von Mozilla verschlüsselt.

Im Gegensatz zu GitCrypt bietet es uns die Möglichkeit, nur die Werte zu verschlüsseln, anstatt die komplette Datei. Somit sind Änderungen einfacher sichtbar.

GitLab unterstützt diverse git push options, mit denen nicht nur Merge Requests erstellt sondern auch mit `merge_request.merge_when_pipeline_succeeds` automatisch akzeptiert werden können, sobald die Pipeline erfolgreich durchgelaufen ist.  

[Hier](https://docs.gitlab.com/ee/user/project/push_options.html) finden sich alle Optionen, die beim Skripting nützlich sein können.

Diese Pipelines sollten optimalerweise einen Smoketest machen, um herauszufinden, ob die neue Konfiguration geeignet ist, damit daraufhin alles weitere auf dem neuen Cluster deployed werden kann.

Hier ein Beispiel mit [Sonobuoy](https://sonobuoy.io/):

```yaml
test:cluster:
    stage: test
    image: sonobuoy/sonobuoy
    only:
        refs:
            - /^infrastructure-*$/
    script:
        - /sonobuoy run --wait --mode quick
```

## Disclaimer

Dies ist ein Ansatz mit wenig overhead, der sich möglicherweise nicht für jeden Usecase eignet. Eine Alternative könnte die Nutzung von [Hashicorp Vault](https://www.hashicorp.com/products/vault) sein.
Vault kümmert sich darum, sensitive Daten zu verwalten und kann sogar Secrets dynamisch in einen Kubernetes Pod einfügen. [Hier](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar/) ein Blogpost dazu.

---


Um auch weitere Cross-Repository Aufgaben mit GitLab zu erledigen, empfehlen wir euch noch folgenden Blogpost: <https://n0r1sk.com/post/2019-09-15-multi-project-pipelines-with-gitlab-ce>

Auch lässt sich sops direkt mit Terraform nutzen: <https://github.com/carlpett/terraform-provider-sops>

