---
title: "Hide your Storage behind Traefik"
date: 2021-08-23T20:15:20Z
draft: false
---

As we transistion from an old fashioned server install for our Ruby application to Kubernetes we needed a solution for all the static assets like images, uploads or feeds.
Our choice was blob storage, since its scalable, cheap and you dont have to care about it yourself. But how should our customers know the new adress? We thought a 301 is a little odd and we couldn't be sure if all requesting endpoints could handle it correctly (I know, sounds cringe but thats how the world is). Also there were concerns from our SEO team that we would loose some of our Google ranking.
As we are as developers, we make the impossible possible:

So we make use of the Kubernetes service feature `ExternalName`. This creates a Kubernetes endpoint to the outside world, in the end its just a CNAME for the original adress.

### Service

Let's start with the service itself

```yaml
apiVersion: v1
kind: Service
metadata:
  name: asset-proxy
spec:
  externalName: ourrubyassets.blob.core.windows.net # this is the bucket name
  ports:
  - name: https
    port: 443
    protocol: TCP
    targetPort: 443
  sessionAffinity: None
  type: ExternalName
```

### Ingress

As seen, there are some basics enabled like gzipping the assets, and enabling all the middleware we are creating down below.

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: web, websecure
    traefik.ingress.kubernetes.io/router.middlewares: proxy-path-rewrite@kubernetescrd,production-static-asset-redirect-header@kubernetescrd,gzip@kubernetescrd
    traefik.ingress.kubernetes.io/router.tls: 'true'
    traefik.ingress.kubernetes.io/router.tls.certresolver: myresolver
  name: asset-proxy
spec:
  rules:
  - host: 'tillepille.io'
    http:
      paths:
      - backend:
          serviceName: asset-proxy
          servicePort: https
        path: '/packs/' # The path for the static files you want to serve
        pathType: ImplementationSpecific
```

### Rewrite

Since we have one Storage Account for multiple buckets and Azure makes your buckets only available as subpaths, we neew to rewrite the request.

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: proxy-path-rewrite
spec:
  replacePathRegex:
    regex: '^/packs/(.*)'
    replacement: '/assets/packs/$1'
```

### Header

We have to rewrite the headers of the request to match the headers for correct TLS connections.

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: proxy-rewrite-header
spec:
  headers:
    customRequestHeaders:
      Authorization: ''
      Host: 'ourrubyassets.blob.core.windows.net' # the name of your original bucket
```

## Full Path

So now, when we have somewhere an image under e.g. `tillepille.io/packs/image.png` the request gets modified to `ourrubyassets.blob.core.windows.net/assets/packs/image.png`.

## Conclusion

Effectivly we are proxying everything through our ingress controller, but together with a CDN in front, we didn't see any issues at all.

The benefit of this is, that you can store all your files on storage you don't have to manage but still keep the full control, how it looks to your customer.
The base concept works for other ingress controller, as well, you just have to find out how to modify the headers.
