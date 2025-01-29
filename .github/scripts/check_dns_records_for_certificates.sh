#!/bin/bash


# This script checks if all DNS resource records exist which are required for the validation/approval of TLS certificate requests in AWS.
failure_occurred=0
aws_region=us-east-1

validate_single_resource_record() {
    # Expects 3 arguments such as:
    # _581a0a3fbce6595214bf90bb7a96aed0.openbrainplatform.org.        CNAME   _53bfbc0e63ca8b8840a176acd644182f.mhbtsbpdnt.acm-validations.aws.
    # It's the DNS record that needs to exist, its type (CNAME) and its value: a URL owned by AWS.
    if [ "$#" -ne 3 ]; then
        echo "Error: 3 arguments expected"
        exit 1
    fi
    local record_name=$1
    # remove the trailing dot if it exists: makes it easier to compare with the expected output of the host command
    record_name="${record_name%.}"
    local record_type=$2
    local record_value=$3

    echo "Record name: $record_name"
    echo "Record type: $record_type"
    echo "Record value: $record_value"

    # Check if the second argument is 'CNAME'
    if [ "$record_type" != "CNAME" ]; then
        echo "Error: The second argument must be 'CNAME', other types are not yet supported."
        exit 1
    fi

    local host_command="host -t cname $record_name"
    local host_output=$(${host_command})

    if [ "${host_output}" == "${record_name} is an alias for ${record_value}" ]; then
    echo "::notice title=DNS check::The CNAME for ${record_name} exists and has the correct value: ${record_value}"
    else
    echo "::error title=DNS check::The CNAME for ${record_name} doesn't exist or doesn't have the correct value. Expected: '${record_name} is an alias for ${record_value}', output: '${host_output}'"
    failure_occurred=1
    fi

}

# For each certificate defined in the deployment, get the ARN of the certificate
for certarn in $(aws --region ${aws_region} acm list-certificates --query 'CertificateSummaryList[].CertificateArn[]' --output text); do \
    # For the selected certificate ARN, get the resource record for the domain validation
    validate_single_resource_record $(aws --region ${aws_region} acm describe-certificate --certificate-arn $certarn --query "Certificate.DomainValidationOptions[].ResourceRecord" --output text)
done

if [ "$failure_occurred" -eq 1 ]; then
    echo "::error title=DNS check::One or more DNS records have issues"
    exit 1
fi
