@extends('admin.layouts.app')

@section('content')
<div class="panel">
    <div class="panel-head">
        <h3>New Leads</h3>
        <span>{{ $total }} users · Logged in but no paid order placed yet</span>
    </div>

    @if ($total === 0)
        <div class="empty-products" style="padding:40px; text-align:center; color:var(--muted)">
            No new leads right now. All registered users have placed orders.
        </div>
    @else
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Joined</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($leads as $lead)
                    <tr>
                        <td>#{{ $lead->id }}</td>
                        <td>
                            <a href="{{ route('admin.users.show', $lead->id) }}" style="color:var(--blue); font-weight:700;">
                                {{ $lead->name ?: 'User #' . $lead->id }}
                            </a>
                        </td>
                        <td>{{ $lead->email }}</td>
                        <td>{{ $lead->created_at ? $lead->created_at->format('d M Y') : '—' }}</td>
                        <td><span class="badge badge-blue">No Order Yet</span></td>
                        <td>
                            <a href="{{ route('admin.users.show', $lead->id) }}" style="font-weight:600; color:var(--blue); font-size:12px;">
                                View User &rarr;
                            </a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    @endif
</div>

<div class="note" style="margin-top: 16px; color: var(--muted); font-size: 12px;">
    Leads = users who signed up / logged in on the mobile app but have not completed a paid order or subscription yet.
</div>
@endsection
