# Regulatory Compliance Workbook

This Azure workbook was initially created to help our Dutch government customers to visualize compliance information produced by the [BIO Compliance Initiative](https://github.com/Azure/Bio-Compliancy). As the workbook targets policy initiatives of category **Regulatory Compliance** it can also be used for other regulatory compliance initiatives.

## Main features:
- Combines policy state information with Defender recommendation severities
- Shows policy state information in the context of Controls, Policy Definitions and Resources
- Shows detailed context information on Exempts, Controls, Policy Definitions and Resources
- Provides several contextual links to relevant Azure portal pages
- Export compliance report to Excel

## Examples

### Overview
<kbd><img src="media/overview-clean.png" alt="overview"></kbd>

### In Context Details
<kbd><img src="media/by-policy-definition.png" alt="overview"></kbd>

### Contextual Links
<kbd><img src="media/recommendations.png" alt="overview"></kbd>

### Export
<kbd><img src="media/export.png" alt="overview"></kbd>



## Deploy the Workbook

The workbook can be deployed in your environment using the **Deploy to Azure** button below. <br><br>
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FEurofiber-CloudInfra%2Fazure-compliance-workbooks%2Fmain%2FARM%2FRegulatory-Compliance-Dashboard.json)

## Open the Workbook

The workbook can be opened from the resource group where it has been deployed or from the **Defender for Cloud** page in the Azure portal. It can be found under the **Workbooks** section (make sure you have select the subscription where the workbook has been deployed). <br><br>
<kbd><img src="media/defender-for-cloud.png" alt="defender"></kbd>

