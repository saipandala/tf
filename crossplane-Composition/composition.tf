apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: s3buckets.opm.paas.org
  labels:
    crossplane.io/xrd: compositeopms3buckets.opm.paas.org
    provider: terraform-provider
    team: opm

spec:
  writeConnectionSecretsToNamespace: crossplane-system
  compositeTypeRef:
    apiVersion: opm.paas.org/v1alpha1
    kind: CompositeOpmS3Bucket
  resources:
    - name: crossplane-tf-s3bucket-opm-pi
      base:
        apiVersion:  tf.crossplane.io/v1alpha1
        kind: Workspace
        spec:
          forProvider:
            module: git::https://github.com/arun12cool/tf.git//tf?ref=main
            source: Remote
            vars:
              - key: LocationConstraint
              - key: acl
              - key: VersioningConfiguration
              - key: Bucket
              - key: Namespace
              - key: Forcedestroy
              - key: env
                value: "Dev"  
          providerConfigRef:
            name: tfproviderconfig-opmpi
          writeConnectionSecretToRef:
            name: opmpi-test
            namespace: crossplane-system



# For the parameter "namespace"
      patches:
# Variables from Claims
        - type: FromCompositeFieldPath
          fromFieldPath: "spec.parameters.LocationConstraint"
          toFieldPath: "spec.forProvider.vars[0].value"
        - type: FromCompositeFieldPath
          fromFieldPath: "spec.parameters.acl"
          toFieldPath: "spec.forProvider.vars[1].value"
        - type: FromCompositeFieldPath
          fromFieldPath: "spec.parameters.VersioningConfiguration"
          toFieldPath: "spec.forProvider.vars[2].value"
        - type: FromCompositeFieldPath
          fromFieldPath: "spec.parameters.Bucket"
          toFieldPath: "spec.forProvider.vars[3].value"
        - type: FromCompositeFieldPath
          fromFieldPath: "spec.parameters.Namespace"
          toFieldPath: "spec.forProvider.vars[4].value"
        - type: FromCompositeFieldPath
          fromFieldPath: "spec.parameters.Forcedestroy"
          toFieldPath: "spec.forProvider.vars[5].value"

# Patching the VAlues to the Variables
# "writeConnectionSecretToRef" Parameter parsing
# For the parameter "name"

#        - type: FromCompositeFieldPath
#          fromFieldPath: "spec.parameters.Namespace"
#          toFieldPath: "spec.writeConnectionSecretToRef.namespace"

#        - type: FromCompositeFieldPath
#          fromFieldPath: "metadata.name"
#          toFieldPath: "spec.writeConnectionSecretToRef.name"
#          transforms:
#            - type: string
#              string:
#                fmt: "v1-%s"


# "providerConfigRef" Parameter parsing
#        - type: CombineFromComposite
#          fromFieldPath: "spec.parameters.providerconfigref"
#          combine: 
#            variables:
#              - fromFieldPath: "spec.parameters.Namespace"
#            strategy: string
#            string:
#                fmt: "tfproviderconfig-%s"
#          toFieldPath: "spec.providerConfigRef.name"
#          policy:
#            fromFieldPath: Required
